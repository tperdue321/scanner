require 'socket' #socket library
class PortScanner
  include Socket::Constants
  
  def initialize(resource_array)
    @resource_array = resource_array
  end

  def self.scan_ports
    PortScanner.new([{host: "etech.svnrepository.com", port: 80},
                      {host: "etech.svnrepository.com", port: 3690},
                      {host: "smtp.sendgrid.net", port: 587},
                      {host: "api.twilio.com", port: 443},
                      {host: "tunnel.us.ngrok.com", port: 443},
                      {host: "cds.etechsystems.com", port: 80},
                      {host: "push.cds.etechsystems.com", port: 80},
                      {host: "s3.amazonaws.com", port: 443},
                      {host: "dev.mysql.com", port: 443},
                      {host: "bitbucket.org", port: 443},
                      {host: "github.com", port: 22},
                      {host: "github.com", port: 443},
                      {host: "github.com", port: 9418},
                      {host: "www.tripplite.com", port: 80},
                      {host: "www.tightvnc.com", port: 80},
                      {host: "java.net", port: 80},
                      {host: "archive.apache.org", port: 80},
                      {host: "dl.google.com", port: 80},
                      {host: "atom.io/download", port: 443},
                      {host: "www.imagemagick.org", port: 80},
                      {host: "download.tortoisegit.org", port: 443},
                      {host: "ftp.gnu.org", port: 80},
                      {host: "sourceforge.net/projects", port: 443},

                    ]).scan_ports
  end

  def check_port(host, port, available_resources, closed_resources)
    begin
      socket = Socket.new(AF_INET, SOCK_STREAM, 0)
      sock_addr = Socket.pack_sockaddr_in(port, host)
      if socket.connect(sock_addr)
        case port
        when 80
          socket.write(" GET / HTTP/1.1\r\n\r\n")
          available_resources.push({host: host, port: port}) 
        when 443
          socket.write(" GET / HTTPS/1.1\r\n\r\n")
          available_resources.push({host: host, port: port}) 
        when 587
          socket.write(" POST / HTTPS/1.1\r\n\r\n")
          available_resources.push({host: host, port: port}) 
        else
          available_resources.push({host: host, port: port}) 
        end
      end
    rescue
      closed_resources.push({host: host, port: port})
    ensure
      begin
        socket.close if socket
      rescue Errno::EBADF
      end
    end
  end

  def scan_ports
    available_resources = []
    closed_resources = []
    @resource_array.each do |resource|
      check_port(resource[:host], resource[:port], available_resources, closed_resources)
    end
    {closed_resources: closed_resources, available_resources: available_resources}
  end
end

