require 'fileutils'

class Shortcuts

  MAPPING = {'m' => 'master', 's' => 'slave', 'c' => 'client'}
  REVERSE_MAPPING = MAPPING.invert
  ARGS = {'master' => '', 'slave' => 'NBDesigner --classloader-public-only', 'client' => 'NBDesigner'}

  def self.bin_dir
    @bin_dir ||= File.absolute_path(File.dirname(__FILE__)).gsub /\//, '\\'
  end

  def self.tmp_io
    return @file if @file
    @file = File.new "link.vbs", 'w' #Tempfile.new('create_demo_links.vbs')
    @file.write %q{Set oWS = WScript.CreateObject("WScript.Shell")}
    @file
  end

  def self.args cfg_name
    ARGS[server_type(cfg_name)]
  end

  def self.server_number(cluster_name)
    File.basename(cluster_name).gsub /cluster/, ''
  end

  def self.client_number(client_name)
    num = 0
    MAPPING.each do |k,v| 
		num +=1 
		if k == client_name or v == client_name
		   return num
		end
	end
  end

  def self.server_type(cfg_name)
    File.basename(cfg_name, '.rb').gsub /_cfg/, ''
  end

  def self.node_name cluster_name, cfg_name
    node_name = REVERSE_MAPPING[server_type(cfg_name)]
    "#{node_name}#{server_number(cluster_name)}"
  end

  def self.create_and_run target_dir
    begin
      Dir["#{bin_dir}/../cluster*"].each do |cluster_name|
        puts "cluster: #{cluster_name}"
        Dir["#{cluster_name}/*_cfg.rb"].each do |cfg_name|
          generate_node_link target_dir, node_name(cluster_name, cfg_name), args(cfg_name)
          generate_log_link target_dir, "#{cluster_name}/.netbeans-#{File.basename(cfg_name, '.rb')}/var/log", node_name(cluster_name, cfg_name)
        end
      end
    ensure
      tmp_io.close
    end
    script_file = File.absolute_path(@file).gsub /\//, '\\'
    begin
      pid = ::Process.spawn "cscript /NOLOGO \"#{script_file}\""
      ::Process.detach pid
    ensure
      sleep 2
      File.delete script_file
    end
  end

  def self.generate_node_link(target_dir, node_name, args)
    puts "link #{target_dir} #{node_name} #{args}"
    lnk_file = "#{bin_dir}\\#{target_dir}\\#{node_name}.lnk"
    File.delete lnk_file rescue nil
    tmp_io.write %Q{
    Set oLink = oWS.CreateShortcut("#{lnk_file}")
    oLink.Arguments =  "#{node_name} #{args}"
    oLink.WorkingDirectory = "#{bin_dir}"
    oLink.Description = "Start test node  #{node_name} #{args}"
    oLink.TargetPath = "#{bin_dir}\\start_rvec_node.bat"
    oLink.Save
    }
  end

  def self.generate_log_link(target_dir, log_dir, node_name)
    log_dir = File.absolute_path(log_dir).gsub /\//, '\\'
    lnk_file = "#{bin_dir}\\#{target_dir}\\#{node_name} log.lnk"
    File.delete lnk_file rescue nil
    FileUtils.mkdir_p log_dir
    tmp_io.write %Q{
    Set oLink = oWS.CreateShortcut("#{lnk_file}")
    oLink.Description = "Logs for node  #{node_name}"
    oLink.TargetPath = "#{log_dir}\\"
    oLink.WorkingDirectory = "#{log_dir}\\"
    oLink.Save
   }
  end

  def self.process
    create_and_run 'shortcuts'
  end
end