task :default => :install

task :install => :dependencies do
  Rake::Task[:stow].execute target: "~", source: "runcom"
  Rake::Task[:stow].execute target: "~/.config", source: "conf"
  Rake::Task[:stow].execute target: "~/.local/share/images", source: "images"
  Rake::Task[:stow].execute target: "~/.local/bin", source: "bin"
  FileUtils.mkdir_p File.expand_path("~/Pictures/Screenshots")
end

task :dependencies do
  lines = File.readlines("dependencies").reject { |line| line[0] == "#" or line == "\n" }
  packages = lines.collect { |s| s.chomp }.join " "

  def installed?(packages)
    system("dpkg-query -s #{packages} > /dev/null 2>&1")
  end

  sh "sudo apt-get install -y #{packages}" unless installed?(packages)
end

task :stow, [:target, :source] do |t, args|
  FileUtils.mkdir_p File.expand_path(args[:target])

  [args[:target], args[:source]].each do |dir|
    abort "stow: #{dir} is not a directory" unless Dir.exist?(File.expand_path(dir))
  end

  require 'find'
  Find.find(args[:source]) do |p|
    next if p == args[:source]

    path = p.sub(args[:source] + "/", "")
    source_path = File.expand_path("#{args[:source]}/#{path}")
    target_path = File.expand_path("#{args[:target]}/#{path}")

    if File.directory?(source_path)
      Dir.mkdir(target_path) unless File.exist?(target_path)
    else
      if File.exist?(target_path)
        unless File.symlink?(target_path) and File.realpath(target_path) == source_path
          abort "stow: #{target_path} already exists"
        end
      else
        File.symlink(source_path, target_path)
      end
    end
  end
end
