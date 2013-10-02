CaseManager
=======

The CaseManager (Code name "Lord Frogington") is a tool to create and group testcases that are then run by the CaseManager Server.
Its purpose is to automaticly test systems and programms.

Installation
=======
1) Install Ruby. 
I recommend version 1.9.3 because that is the version I used when testing the tool but I guess it would run on Ruby 2.0.0 just fine

2) Install PostgreSQL. 
On Linux use "sudo apt-get install postgresql" and "sudo apt-get install postgresql-dev" to install the programm. You dont need to create any databases yourself.

3) Download/Clone Repository. 
Clone this repository or donwload and extract the .zip file to your computer.

4) Install Ruby gems. 
Just Run "bundle install" on your commandline while you are in the project folder. If you don't have the bundler run "gem install bundler" first. I may have made mistakes in the gemfile so if you're getting errors try installing missing gem manually via "gem install <gemname>"

5) Ready to go.
You should be fine to start the CaseManager now. Just run "ruby app.rb" while you are in the project folder.

How to use this Tool
=======
Click "New Case" to create your first code. You will see a form with the following fields:
	* Name: The Name of the case. You can leave this field empty, if you do the case won't appear on the main screen.
	* Tags: Tags are used to search through all your cases. They work kinda like projects in different tools.
	* Comment: Write a comment to describe your case if you want to.
	* Input-Variables: Write a list of variables you want the user to pass. Use a "," to seperate these names not a ", "!
	* Code: Write any Ruby code you like here. It will be run once the case is executed.
	
Click "New Group" to create your first group. A group is a collection of cases and other groups. You will see a list of all created cases and groups on the right side of the screen. Use drag and drop to add cases to your group.
Once you have created your group it will apear on the main screen with two small buttons behind its name. The first "Play"-Button will run the group. The second "Edit"-Button allwos you to edit your group.

Click the small "Play"-Button to run a group. Once you clicked it you will see a small form with a field containing a number (the ID of your group) if you added User-Variables to your cases all of them are listed too. Click run and all Cases in the chosen group will be executed one after another.

After a run is complete you will be redirected to the result screen. Every test-case is listed here with a small picture indicating the result of that case.

How to set results
======
In your case you can use some basic functions to set the result of the case.
	* Equal(A,B) cheacks if value A and B are equal and sets the Result to passed or failed
	* SetResult(true/false) sets the result to passed or failed. This function will only set the result to true if its not already false so you can use it multiple times in a single case.
	* Log("String") This String will appear in your resultscreen. It doesn't change the result icon of the case.
	
There are some other states that a case can have:
	* Error: Something is wrong with your Ruby syntax
	* Overtime: The case took longer then 60 Seconds and was aborted (You can set @runtime = 10 to just let a case run 10seconds before its aborted or @runtime = 9999999999 if you dont want to abort it in the next year)
	* Undefined: There was no function modifying the result of this case. Nothing went wrong nothing right it was just executed without any tests.
	
How to run my groups automaticly
======
Use a HTTP-Request (For example with curl) to run any group you created. You can send a get request to "<yourserver>/run/<id of group>" or a post request to "<yourserver>/run" wich posts a JSON object containing a field "id" and fields for all user-variables.
