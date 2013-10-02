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
	- Name: The Name of the case. You can leave this field empty, if you do the case won't appear on the main screen.
	- Tags: Tags are used to search through all your cases. They work kinda like projects in different tools.
	- Comment: Write a comment to describe your case if you want to.
	- Input-Variables: Write a list of variables you want the user to pass. Use a "," to seperate these names not a ", "!
	- Code: Write any Ruby code you like here. It will be run once the case is executed.
