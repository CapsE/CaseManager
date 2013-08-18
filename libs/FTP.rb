require 'net/ftp'
	
def FTP_Login url, user, passwd
	@ftp=Net::FTP.new
	@ftp.connect(url,21)
	@ftp.login(user,passwd)
	Exists(@ftp.welcome)
	return url
end

def FTP_ChangeDir dir
	@ftp.chdir(dir)
	Exists(@ftp.welcome)
	return dir
end

def FTP_GetFile file
	@ftp.get(file, "files/#{file}")
	if File.open(file) != nil
		SetResult(true)
	else
		SetResult(false)
	end
	@file = file
	return file
end

def FTP_Close
	@ftp.close
	Equal(@ftp.lastresp, "226")
end
