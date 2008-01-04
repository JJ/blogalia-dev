// ==UserScript==
// @name		  Etiquetas
// @namespace	  http://atalaya.blogalia.com
// @description	  Añade etiquetas a entradas blogalia
// @include	  http://*blogalia.com/*
// ==/UserScript==

// based on code by Phil Wilson, Robert De Almeida, and Jeff Minard
// and included here with their gracious permission
function add_tags(s) {
  var tags = s.split(/,\s+/);
  var result='';
  for ( var i=0; i < tags.length; i++ ) {
    result += "<a href='http://www.technorati.com/tag/"+tags[i]+"'>"+tags[i]+"</a> ";
  }
  return result;
}

var registro_a = document.getElementsByName("registro[contenido]");
var registro = registro_a[0];
var etiquetas = document.createElement("input");
etiquetas.type = 'text';
etiquetas.size = '60'
etiquetas.value = 'Etiquetas, separadas, por comas';
var elmButton = document.createElement("input");
elmButton.type = "button";
elmButton.value = "Añade Tags";
elmButton.addEventListener('click', function() {
			     registro.value += add_tags(etiquetas.value);
			   }, true);
registro.parentNode.insertBefore(etiquetas,
				 registro.nextSibling);

registro.parentNode.insertBefore(elmButton,
				 etiquetas.nextSibling);
