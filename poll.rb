require 'sinatra'
require 'sequel'

configure do
  # load database
  DB = Sequel.sqlite('pollresults.db')
end

helpers do
 def display_results(results)
   total_votes = results.get(:option1) + results.get(:option2) + results.get(:option3)
   
     value = (results.get(:option1) / total_votes.to_f) * 100
     output = draw_bar value
     value = (results.get(:option2) / total_votes.to_f) * 100
     output += draw_bar value
     value = (results.get(:option3) / total_votes.to_f) * 100
     output += draw_bar value
     
     #output
 end
 
 #for bar graph
 def draw_bar (percentage)
   "<div style='width:300px; height:20px; background-color:#CCC;'>
       <div style='width:#{percentage}%; height:20px; background-color:#666; border-right:1px #FFF solid;'>
       </div>
     </div><br />"
 end
end

get '/poll/?' do
  <<-form
  <h3>What's your favorite movie?</h3>
  <form method="post">
    <input type="radio" name="movie" value="option1" /> Pulp Fiction <br />
    <input type="radio" name="movie" value="option2" /> Oldboy <br />
    <input type="radio" name="movie" value="option3" /> The Professional <br />
    <br />
    <input type="submit" value="Submit Choice" />
  </form>
  form
end

post '/poll' do
  results = DB[:pollresults]
  if params[:movie] == 'option1' then
    result = results.get(:option1)
    results.select(:option1).update(:option1 => result += 1)
  elsif params[:movie] == 'option2' then
    result = results.get(:option2)
    results.select(:option2).update(:option2 => result += 1)
  else
    result = results.get(:option3)
    results.select(:option3).update(:option3 => result += 1)
  end
  
  display_results(results)
end
