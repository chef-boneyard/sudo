#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Author:: Seth Vargo (<sethvargo@gmail.com>)
# Cookbook:: sudo
# Resource:: default
#
# Copyright:: 2011-2016, Bryan w. Berry
# Copyright:: 2012-2016, Seth Vargo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

property :user,              String
property :group,             String
property :commands,          Array,            default: ['ALL']
property :host,              String,           default: 'ALL'
property :runas,             String,           default: 'ALL'
property :nopasswd,          [true, false],    default: false
property :noexec,            [true, false],    default: false
property :template,          String
property :variables,         [Hash, nil],      default: nil
property :defaults,          Array,            default: []
property :command_aliases,   Array,            default: []
property :setenv,            [true, false],    default: false
property :env_keep_add,      Array,            default: []
property :env_keep_subtract, Array,            default: []

# Default action - install a single sudoer
action :install do
  target = "#{node['authorization']['sudo']['prefix']}/sudoers.d/"

  package 'sudo' do
    not_if 'which sudo'
    action :nothing
  end.run_action(:install)

  unless ::File.exist?(target)
    directory target do
      action :nothing
    end.run_action(:create)
  end

  render_sudoer

  Chef::Log.warn("#{sudo_filename} will be rendered, but will not take effect because node['authorization']['sudo']['include_sudoers_d'] is set to false!") unless node['authorization']['sudo']['include_sudoers_d']
end

# Removes a user from the sudoers group
action :remove do
  file "#{node['authorization']['sudo']['prefix']}/sudoers.d/#{sudo_filename}" do
    action :delete
  end
end

action_class do
  # Ensure that the inputs are valid (we cannot just use the resource for this)
  def check_inputs(_user, _group, _foreign_template, _foreign_vars)
    # if group, user, and template are nil, throw an exception
    if new_resource.user.nil? && new_resource.group.nil? && new_resource.foreign_template.nil?
      raise 'You must provide a user, group, or template!'
    elsif !new_resource.user.nil? && !new_resource.group.nil? && !tnew_resource.emplate.nil?
      raise 'You cannot specify user, group, and template!'
    end
  end

  # Validate the given resource (template) by writing it out to a file and then
  # ensuring that file's contents pass `visudo -c`
  def validate_fragment!(resource)
    file = Tempfile.new('sudoer')

    begin
      file.write(capture(resource))
      file.rewind

      cmd = Mixlib::ShellOut.new("visudo -cf #{file.path}").run_command
      unless cmd.exitstatus == 0
        Chef::Log.error("Fragment validation failed: \n\n")
        Chef::Log.error(file.read)
        Chef::Application.fatal!("Template #{file.path} failed fragment validation!")
      end
    ensure
      file.close
      file.unlink
    end
  end

  # Render a single sudoer template. This method has two modes:
  #   1. using the :template option - the user can specify a template
  #      that exists in the local cookbook for writing out the attributes
  #   2. using the built-in template (recommended) - simply pass the
  #      desired variables to the method and the correct template will be
  #      written out for the user
  def render_sudoer
    if new_resource.template
      Chef::Log.debug('Template property provided, all other properties ignored.')

      resource = template "#{node['authorization']['sudo']['prefix']}/sudoers.d/#{sudo_filename}" do
        source new_resource.template
        owner 'root'
        group node['root_group']
        mode '0440'
        variables new_resource.variables
        action :nothing
      end
    else
      sudoer = new_resource.user || ("%#{new_resource.group}".squeeze('%') if new_resource.group)

      resource = template "#{node['authorization']['sudo']['prefix']}/sudoers.d/#{sudo_filename}" do
        source 'sudoer.erb'
        cookbook 'sudo'
        owner 'root'
        group node['root_group']
        mode '0440'
        variables sudoer:             sudoer,
                  host:               new_resource.host,
                  runas:              new_resource.runas,
                  nopasswd:           new_resource.nopasswd,
                  noexec:             new_resource.noexec,
                  commands:           new_resource.commands,
                  command_aliases:    new_resource.command_aliases,
                  defaults:           new_resource.defaults,
                  setenv:             new_resource.setenv,
                  env_keep_add:       new_resource.env_keep_add,
                  env_keep_subtract:  new_resource.env_keep_subtract
        action :nothing
      end
    end

    # Ensure that, adding this sudoer, would not break sudo
    validate_fragment!(resource)

    resource.run_action(:create)
  end

  # acording to the sudo man pages sudo will ignore files in an include dir that have a `.` or `~`
  # We convert either to `__`
  def sudo_filename
    new_resource.name.gsub(/[\.~]/, '__')
  end

  # Capture a template to a string
  def capture(templ)
    context = {}
    context.merge!(templ.variables)
    context[:node] = node

    eruby = Erubis::Eruby.new(::File.read(template_location(templ)))
    eruby.evaluate(context)
  end

  # Find the template
  def template_location(templ)
    if templ.local
      templ.source
    else
      context = templ.instance_variable_get('@run_context')
      cookbook = context.cookbook_collection[templ.cookbook || templ.cookbook_name]
      cookbook.preferred_filename_on_disk_location(node, :templates, templ.source)
    end
  end
end
