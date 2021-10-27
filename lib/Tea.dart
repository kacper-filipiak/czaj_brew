class Tea{
    final String description;
    final String name;
    final List<int> brew_time;


    Tea(this.name, this.description, this.brew_time);
    @override
    String toString(){
        String brews = "";
        for( var i in brew_time){
           brews+=i.toString() + ' '; 
        }
        return 'Tea: ${name}, ${description}, brewing times:  ${brews}';
    }
}
