# frozen_string_literal: true

pid = File.open('pid.txt', &:read)
Process.kill('INT', pid.to_i)
