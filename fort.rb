require 'etc'
require 'io/console'

def execute_command_as_root(command)
  uid = Process::UID.eid
  gid = Process::GID.eid

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
  true
  # Здесь вы можете разместить условие, когда требуется ввод пароля,
  # например, наличие определенного файла или другой кастомной проверки
end

def check_root_password(password)
  # Здесь вы можете реализовать проверку введенного пароля от root пользователя
  # Например, можно сравнить хеш пароля с заранее сохраненным
  # или использовать другой механизм аутентификации root пользователя
end

# Пример использования:
command = ARGV[0]
status = execute_command_as_root(command)

puts "sucess" if status.success?
puts "error" unless status.success?
