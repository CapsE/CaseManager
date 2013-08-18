#*****************************************************************************************************************
# User-Input Interface
#*****************************************************************************************************************
# Zeigt ein User-Input Interface fallse UserInput erforderlich ist. Ansonsten wird der Test sofort ausgeführt
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
# Funktion zum ausführen einer Gruppe
#*****************************************************************************************************************
# Führt der Reihe nach alle Elemente von "group" aus. Ist ein Element selbst eine Gruppe wird die Funktion 
# rekursiv aufgerufen.
#*****************************************************************************************************************
def runGroup group
	@tree += "<div class='tree_group'><img class='identifier' src='Icons/hide.png' onclick='Toggle(event, \"item_#{@id}\")'>"
	@tree += "  #{group.tags}<div>"
	@tree += "</div><ul id='item_#{@id}'>"
	@id +=1
	group.elements.split(",").each do |el|
		if el[0] == "C"
			$result = nil
			$log = ""
			c = Case.find(el[1..-1])
			@tree += "<li class='tree_case'>#{c.tags}</li>"
			eval(c.code)
			if $result == false
				@tree += '<img class="control" src="Icons/fail.png">'
			elsif $result == true
				@tree += '<img class="control" src="Icons/check.png">'
			else
				@tree += '<img class="control" src="Icons/unknown.png">'
			end
			if $log 
				@tree += "<p><code class='log_case'>#{$log}</code>"
			end
		else
			g = Group.find(el[1..-1])
			runGroup(g)
		end
	end
	@tree += "</ul>"
	File.open("views/result.erb", 'a') { |file| file.write(@tree) }
end

#*****************************************************************************************************************
# POST-Request zum ausführen einer Gruppe
#*****************************************************************************************************************
# Führt die Gruppe mit parametern aus
#*****************************************************************************************************************
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
	@tree = ""
	@id = 0
	runGroup(@group)
	redirect "/result"
end

#*****************************************************************************************************************
# GET-Request zum ausführen einer Gruppe
#*****************************************************************************************************************
# Führt die Gruppe ohne Parameter aus
#*****************************************************************************************************************
get "/runwo/:id" do
	@group = Group.find(params[:id])
	@title = "compiling..."
	$result = nil
	$log = ""
	
	File.open("views/result.erb", 'w') { |file| file.write("<h1>Result</h1>") }
	@tree = ""
	@id = 0
	runGroup(@group)
	redirect "/result"
end
