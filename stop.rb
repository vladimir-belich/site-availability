pid = File.open('pid.txt'){ |file| file.read }
Process.kill("QUIT", pid.to_i)