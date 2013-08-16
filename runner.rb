get "/run/:id" do
	@group = Group.find(params[:id])
	@title = "Waiting..."
	@var = 0
	
	def SearchInput group
		group.elements.split(",").each do |el|
			if el[0] == "C"
				classname = "case"
				c = Case.find(el[1..-1])
				inputs = c.input.split(",")
				if inputs != nil
					@var += 1
				end
			else
				SearchInput(Group.find(el[1..-1]))
			end
		end
	end

	SearchInput(@group)
	if @var == 0
		redirect "/runwo/#{params[:id]}"
	end
	erb :input
end

def runGroup group
	@html += '<div class="group"><h2>#' + group.id.to_s + " " + group.tags + "</h2>"
	group.elements.split(",").each do |el|
		if el[0] == "C"
			$result = nil
			$log = ""
			c = Case.find(el[1..-1])
			@html += '<div class="case">#' + el[1..-1] + ' ' + c.tags
			eval(c.code)
			if $result == false
				@html += '<div class="result" style="background:red"></div>'
			elsif $result == true
				@html += '<div class="result"style="background:green"></div>'
			else
				@html += '<div class="result"style="background:grey"></div>'
			end
			@html += "<p>" + $log
			@html += "</div>"
		else
			g = Group.find(el[1..-1])
			runGroup(g)
		end
	end
	@html += "</div><br>"
	File.open("views/result.erb", 'a') { |file| file.write(@html) }
end
	
post "/run" do
	@input = params[:post]
	puts "--------------------"
	puts params
	puts ".----------------------"
	puts @input
	puts ".--------------------"
	
	@group = Group.find(params[:post][:id])
	@title = "compiling..."
	$result = nil
	$log = ""
	
	File.open("views/result.erb", 'w') { |file| file.write("<h1>Result</h1>") }
	@html = ""
	runGroup(@group)
	redirect "/result"
end

get "/runwo/:id" do
	@group = Group.find(params[:id])
	@title = "compiling..."
	$result = nil
	$log = ""
	
	File.open("views/result.erb", 'w') { |file| file.write("<h1>Result</h1>") }
	@html = ""
	runGroup(@group)
	redirect "/result"
end
