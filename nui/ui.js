/* 
    vrp_spawn_screen
    Copyright (C) 2018  VHdk

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

$(document).ready(function(){
 
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
  
        if ( item.showPlayerMenu == true ) {
	        $('body').css('background-color','transparent');
	        $('body').css('background','url("background.jpg") no-repeat center center fixed');
          
            $('.container-fluid').css('display','block');
        } else if ( item.showPlayerMenu == false ) { // Hide the menu 
           
            $('.container-fluid').css('display','none');
            $('body').css('background-color','transparent important!');
	        $("body").css("background-image","none");

        }
    } );

    $('#spawn-button').click(function(){
        $('#spawn-button').fadeOut("slow",function(){
          $("#container, #gender-container").fadeIn();
        });
      });
      
    $("#spawnbtn").click(function(e){
        firstname = $('#firstname').val();
        lastname = $('#lastname').val();
        age = $('#age').val();
        gender = $('input[name="gender"]:checked').val();

        $.post('http://vrp_spawn_screen/spawnButton', JSON.stringify({
            firstname : firstname,
            lastname : lastname,
            age : age,
            gender : gender
        
        }));


        $('.container-fluid').css('display','none');
        $('body').css('background-color','transparent important!');
        $("body").css("background-image","none");
        $("#container, #gender-container").fadeOut(800, function(){
            $("#spawn-button").fadeIn(800);
        });

    });


})
