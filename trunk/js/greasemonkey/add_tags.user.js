// ==UserScript==
// @name	  Etiquetaiser
// @namespace	  http://atalaya.blogalia.com
// @description	  Añade etiquetas a entradas blogalia
// @include	  http://*.blogalia.com/bitacora.historias*
// ==/UserScript==

// based on code by Phil Wilson, Robert De Almeida, and Jeff Minard

// Añade etiquetas a partir de la cadena introducida
function add_tags(s) {
  var tags = s.split(/,\s+/);
  var result='\n<span class="etiquetas_technorati">Etiquetas: ';
  for ( var i=0; i < tags.length; i++ ) {
    result += "<a rel='tag' href='http://www.technorati.com/tag/"+tags[i]+"'>"+tags[i]+"</a> ";
    if ( i < (tags.length-1) ) {
      result += ", ";
    }
  }
  return result+"</span>";
}

//Extrae la parte del formulario
var registro_a = document.getElementsByName("registro[contenido]");
var registro = registro_a[0];

//Añade formulario para etiquetas
var etiquetas = document.createElement("input");
etiquetas.type = 'text';
etiquetas.size = '60'
etiquetas.value = 'Etiquetas, separadas, por comas';

//Añade botón
var elmButton = document.createElement("input");
elmButton.type = "button";
elmButton.value = "Añade Tags";
elmButton.addEventListener('click', function() {
			     registro.value += add_tags(etiquetas.value);
			   }, true);

//Lo coloca en la página
registro.parentNode.insertBefore(etiquetas,
				 registro.nextSibling);

registro.parentNode.insertBefore(elmButton,
				 etiquetas.nextSibling);
