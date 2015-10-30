require 'tempfile'

class Shortcuts

  MAPPING = {'m' => 'master', 's' => 'slave', 'c' => 'client'}
  REVERSE_MAPPING = MAPPING.invert
  puts REVERSE_MAPPING.inspect
  ARGS = {'master' => '', 'slave' => 'NBDesigner', 'client' => 'NBDesigner'}

  def bin_dir
    @bin_dir ||= File.dirname(__FILE__).gsub /\//, '\\'
  end

  def tmp_io
    @file ||= File.new "link.vbs", 'w' #Tempfile.new('create_demo_links.vbs')
  end

  def args cfg_name
    ARGS[server_type(cfg_name)]
  end

  def server_number(cluster_name)
    File.basename(cluster_name).gsub /cluster/, ''
  end

  def server_type(cfg_name)
    File.basename(cfg_name, '.rb').gsub /_cfg/, ''
  end

  def node_name cluster_name, cfg_name
    node_name = REVERSE_MAPPING[server_type(cfg_name)]
    "#{node_name}#{server_number(cluster_name)}"
  end

  def create_and_run target_dir
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
      sleep 3
      File.delete script_file
    end
  end

  def generate_node_link(target_dir, node_name, args)
    puts "link #{target_dir} #{node_name} #{args}"
    tmp_io.write %Q{
    Set oWS = WScript.CreateObject("WScript.Shell")
    sLinkFile = "#{bin_dir}\\#{target_dir}\\#{node_name}.lnk"
    Set oLink = oWS.CreateShortcut(sLinkFile)
    oLink.Arguments =  "#{node_name} #{args}"
    oLink.WorkingDirectory = "#{bin_dir}"
    oLink.Description = "Start test node  #{node_name} #{args}"
    oLink.TargetPath = "#{bin_dir}\\start_rvec_node.bat"
    oLink.Save
    }
  end

  def generate_log_link(target_dir, log_dir, node_name)
    tmp_io.write %Q{
    Set oWS = WScript.CreateObject("WScript.Shell")
    sLinkFile = "#{bin_dir}\\#{target_dir}\\#{node_name} log.lnk"
    Set oLink = oWS.CreateShortcut(sLinkFile)
    oLink.Description = "Logs for node  #{node_name}"
    oLink.TargetPath = "#{log_dir}"
    oLink.Save
   }
  end

  def self.process
    new.create_and_run 'shortcuts'
  end
end

Shortcuts.process