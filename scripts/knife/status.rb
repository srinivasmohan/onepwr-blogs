#Run this from your Knife folder with "knife exec /pathto/status.rb"
stats=Array.new
sizes=[0,0,0]
TimeFormat="%F %R"
Sep='|'

nodes.all do |thisnode|
  checkintime=Time.at(thisnode['ohai_time']).to_i
  rubyver = thisnode['languages']['ruby']['version']
  recipes = thisnode.run_list.expand(thisnode.chef_environment).recipes.join(",")
  sizes[0]=thisnode.name.length if thisnode.name.length>sizes[0]  
  sizes[1]=rubyver.length if rubyver.length>sizes[1]
  sizes[2]=recipes.length if recipes.length>sizes[2]
  stats.push([checkintime,thisnode.name, rubyver, recipes])
end

sizes.unshift(Time.now.strftime(TimeFormat).to_s.length)
formatstring="|";
sizes.each do |y|
	formatstring=formatstring+"%#{y}s|"
end

printf "#{formatstring}\n", "CheckIn", "NodeName", "Ruby", "Recipes"
stats.sort{|x,y| x[0] <=> y[0]}.each do |x|
x[0]=Time.at(x[0]).strftime(TimeFormat)
printf "#{formatstring}\n",*x
end
