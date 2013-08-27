def Log text
	$log += "#{text}"
end

def SetResult bool
	if $result != "false"
		if bool
			$result = "true"
		else
			$result = "false"
		end
	end
end

def Equal a,b
	if a == b
		SetResult(true)
	else
		SetResult(false)
	end
end

def Exists a
	if a != nil
		SetResult(true)
	else
		SetResult(false)
	end
end

def WriteFile name, content
	File.open("files/#{name}", 'w') { |file| file.write(content) }
	SetResult(true)
	return name
end

def DownloadLink file, name = nil
	if name == nil
		name = file
	end
	SetResult(true)
	Log("<a href='/download/#{file}'>#{name}</a>")
end