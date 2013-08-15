def Log text
	$log += "<code>#{text}</code>"
end

def Equal a,b
	if a == b
		$result = true
	else
		$result = false
	end
end