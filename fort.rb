require 'etc'
require 'io/console'

def execute_command_as_root(command)
  uid = Etc.getpwnam('root').uid
  gid = Etc.getgrnam('root').gid

  if require_root_password?
    print '[password]: '
    password = STDIN.noecho(&:gets).chomp
    unless check_root_password(password)
      puts 'fort: Permision denied'
      return false
    end
  end

  Process.fork do
    Process::Sys.setuid(uid)
    Process::Sys.setgid(gid)

    exec command
  end

  _, status = Process.wait2
  status
end

def require_root_password?
  return true
end

def check_root_password(password)

end

# Пример использования:
command = ARGV[0]
status = execute_command_as_root(command)

puts "sucess" if status.success?
puts "error" unless status.success?
