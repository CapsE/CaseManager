def Log text
	$log += "<code>#{text}</code><p>"
end

def SetResult bool
	if $result != false
		$result = bool
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