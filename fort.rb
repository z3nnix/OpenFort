require 'etc'
require 'io/console'

config = File.read("/bin/fort.config")
eval(config)

def execute_command_as_root(command)
  uid = Process::UID.eid
  gid = Process::GID.eid

  if require_root_password?
    print '[password]: '
    password = STDIN.noecho(&:gets).chomp
    puts "\n"
    tmp = check_root_password(password)
    
    if tmp != true
 	puts tmp
	exit
    end
  end

  Process.fork do
    Process::Sys.setuid(uid)
    Process::Sys.setgid(gid)
    system("#{command}")
  end

  _, status = Process.wait2
  status
end

def require_root_password?
  return PassRequire
end

def check_root_password(password)
  if password != RootPass
    return "fort: Permission denied / wrong password"
  else
    return true
  end
end

command = ARGV[0]
status = execute_command_as_root(command)