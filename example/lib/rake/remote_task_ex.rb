require 'rake/remote_task'

class Rake::RemoteTask
  alias run_org run
  def run command
    options = []
    options << "export http_proxy=#{http_proxy}"    if defined?(http_proxy) && http_proxy
    options << "export https_proxy=#{https_proxy}"  if defined?(https_proxy) && https_proxy
    options << command
    run_org options.join(' && ')
  end

  alias sudo_org sudo
  def sudo command
    proxies = []
      proxies << "http_proxy=#{http_proxy}"   if defined?(http_proxy) && http_proxy
      proxies << "https_proxy=#{https_proxy}" if defined?(https_proxy) && https_proxy

    command = ['env', proxies, command].flatten.compact.join(" ") if proxies.size > 0
    sudo_org command
  end
end
