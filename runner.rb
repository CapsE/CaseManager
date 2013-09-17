#*****************************************************************************************************************
# User-Input Interface
#*****************************************************************************************************************
# Zeigt ein User-Input Interface fallse UserInput erforderlich ist. Ansonsten wird der Test sofort ausgef�hrt
#*****************************************************************************************************************
get "/run/:id" do
	@group = Group.find(params[:id])
	@title = "Waiting..."
	@var = 0
	@tree = ""
	@id = 0	
	
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

#*****************************************************************************************************************
# Funktion zum ausf�hren einer Gruppe
#*****************************************************************************************************************
# F�hrt der Reihe nach alle Elemente von "group" aus. Ist ein Element selbst eine Gruppe wird die Funktion 
# rekursiv aufgerufen.
#*****************************************************************************************************************
def runGroup group
	@tree += "<div class='tree_group'><img class='identifier' src='/Icons/hide.png' onclick='Toggle(event, \"item_#{@id}\")'>"
	@tree += "  #{group.tags}<div>"
	@tree += "</div><ul id='item_#{@id}'>"
	@id +=1
	group.elements.split(",").each do |el|
		if el[0] == "C"
			$result = nil
			$log = ""
			c = Case.find(el[1..-1])
			@tree += "<li class='tree_case'>#{c.tags}  "
			#Ausf�hren des eigengebenen Codes
			@runtime = 60
			thread = Thread.new{
				begin
					eval(c.code)
				rescue
					$result = "crash"
				end
			}
			sleep 0.001
			if @runtime != nil
				stopTime = Time.now + @runtime
				while thread.alive? && Time.now <= stopTime		
				end
				if thread.alive?
					$result = "time"
				end
			else
				while thread.alive?		
				end
			end
			Thread.kill(thread)	
			
			if $result == "false"
				@tree += '<img class="result" src="/Icons/fail.png">'
			elsif $result == "true"
				@tree += '<img class="result" src="/Icons/check.png">'
			elsif $result == "time"
				@tree += '<img class="result" src="/Icons/time.png">'
			elsif $result == "crash"
				@tree += '<img class="result" src="/Icons/crash.png">'
			else
				@tree += '<img class="result" src="/Icons/unknown.png">'
			end
			if $log != ""
				@tree += "<p><code class='log_case'>#{$log}</code>"
			end
			@tree += "</li>"
		else
			g = Group.find(el[1..-1])
			runGroup(g)
		end
	end
	@tree += "</ul>"
	return @tree
end

#*****************************************************************************************************************
# POST-Request zum ausf�hren einer Gruppe
#*****************************************************************************************************************
# F�hrt die Gruppe mit parametern aus
#*****************************************************************************************************************
post "/run" do
	@input = params[:post]
	if @input == nil
		@input = params
	end
	puts "--------------------"
	puts params
	puts ".----------------------"
	puts @input
	puts ".--------------------"
	
	@group = Group.find(params[:post][:id])
	@title = "compiling..."
	$result = nil
	$log = ""
	
	@tree = ""
	@id = 0
	@tree = runGroup(@group)
	
	t = Time.new
	time = "#{t.day}-#{t.month}-#{t.year}_#{t.hour}-#{t.min}-#{t.sec}"
	File.open("files/results/#{time}_result.res", 'w') { |file| file.write(@tree) }
	
	redirect "/result/#{time}_result.res"
end

#*****************************************************************************************************************
# GET-Request zum ausf�hren einer Gruppe
#*****************************************************************************************************************
# F�hrt die Gruppe ohne Parameter aus
#*****************************************************************************************************************
get "/runwo/:id" do
	@group = Group.find(params[:id])
	@title = "compiling..."
	$result = nil
	$log = ""
	@tree = ""
	@id = 0
	@tree = runGroup(@group)
	
	t = Time.new
	File.open("files/results/#{t.to_s}_#{@group.tags}", 'w') { |file| file.write(@tree) }
	
	redirect "/result"
end
