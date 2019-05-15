# Coldline Necrobyl
Coldline Necrobyl es un juego de disparos con vista cenital con una fuerte inspiración de juegos como "Hotline Miami" y "Counter-Strike 2D".

# Mecanicas que queriamos implementar
En el comienzo del desarrollo, queriamos implementar un gran número de mecánicas jugables:

    ✓ Varias armas que se recogen al pasar por encima. Munición limitada con cargadores, desapaercen cuando te quedas sin munición.
    ✗ Se pueden tirar las armas con click derecho.
    ✓ Pistola como arma principal. Tiene munición infinita.
    ✗ Cajas de munición en los niveles.
    ✗ 3 tipos de healthpack (sprite de botella de Vodka). Pequeño, mediano y grande.
    ✗ Si estas al máximo de vida y te curas, entras en un bufo temporal en el que no gastas munición y te hacen menos daño. Todo esto con efectos visuales y cambiando la música del nivel.
    ✓ Estructura "Intermission" -> "Nivel" -> "Intermission" -> ...
    ✓ En los "Intermission": desarrollo de la historia mediante dialogos.
    ✓ En los niveles: acción.
    ✓ Varios tipos de zombies (normal, rapido y debil, lento y fuerte, normal que dispara).
    ✓ Aumento de visión (no puedes disparar cuando lo haces).
    ✓ Un jefe cada cada tercer nivel normal.
    ✓ Reinicio rápido de nivel (como en Hotline Miami).
    ✓ Cambios de iluminación entre zonas abiertas y cerradas.
    
Debido a la falta de tiempo, o a que igual las mecánicas no terminaban de funcionar, varias de las anteriores se quedaron solo como ideas:

    - Decidimos descartar que las armas pudieran tirarse para simplificar el código y tener más tiempo para cosas más importantes.
    - Cambiamos el funcionamiento de la munición para que funcionara sin cargadores.
    - Tambien nos deshicimos de las cajas de munición.
    - No hemos podido implementar el bufo cuando te curas por falta de tiempo.
    
# Problemas y soluciones durante el desarrollo
Durante el desarrollo tuvimos varios problemas:

    - El repositorio era muy pesado cada vez que teniamos que hacer "git pull". Esto se debía a los archivos de audio, que estaban en .wav. 
      Lo solucionamos cambiando el formato de .wav a .ogg (unas 10 veces más ligeros).
    - En un principio estabamos teniendo problemas con git y con como organizar el proyecto. Poco a poco fuimos estructurandolo todo.
    - En Godot, no puede haber dos "tiles" superpuestos si pertenecen al mismo nodo. Lo arreglamos separando los "tiles" en varios nodos.
    - En los ordenadores menos potentes, la cámara se volvía inestable. Esto se debia a una propiedad de la misma para suavizar los movimientos.
      Al quitar esta opción se arreglaba el error, y aunque quedaba menos pulido, decidimos poner en prioridad la estabilidad del juego.
    - Varias canciones que queriamos meter tenian una parte de introducción que duraba mucho rato.
      Conseguimos saltarnos estas partes con un script que indica en que minuto tiene que empezar la canción en cada nivel.
    - Los dialogos se rompían con frecuencia. Esto se debía a que no estabamos enviando bien las "señales" (eventos) de Godot.
    - Las armas automáticas dejaban de funcionar tras la primera bala. Cambiando la lógica de la parte automática arreglamos el error.
    - Los niveles empezaban siempre en oscuro, aunque estuvieras en el exterior.
      Añadiendo "Start tint enabled" en los scripts de nivel podiamos controlar este comportamiento.
    - Se podía disparar dentro del "Intermission", cosa que no debería poderse.
      Hicimos una escena "playerIntermission" con funcionalidades reducidas solo para el "Intermission".
    - Los healthpacks aumentaban vida aunque estuvieras al máximo.
      Arreglamos esto haciendo una comparación entre la vida despues de curarse y la vida máxima.
    - Las animaciones del personaje eran toscas y a veces dejaban de funcionar. Esto se debia a que funcionaban con inputs de teclado.
      Cambiamos la animacion para que se ejecutara cuando el jugador cambiara de posición en vez de por inputs.
    - Las transiciones entre escenas se cortaban a mitad. Poniendo un delay antes de cambiar de escena solucionamos el problema.
    - El cambio al arma básica al quedarse sin munición dejaba desarmado al jugador. Esto era causado a que lanzabamos una función
      para borrar el arma anterior dos veces. Quitando una se arreglaba el problema.
    - Los sprites de arma eran muy pequeños. Usamos la propiedad "Scale" en Godot para aumentar el tamaño.
    - Al acabar el nivel, no se cambiaba de escena. Esto se debia a los nombres de las escenas.
      Tiene que haber siempre un "intermissionX" y un "levelX" para que el juego reconozca la siguiente.
    - La UI no se actualizaba con los cambios del juego. 
      Tuvimos que crear un script en "Autoload" que actuara de intermediario entre el juego y la UI.
    - La escopeta tenia un sistema de disparo distinto al que teniamos de standar.
      Tuvimos que hacer un script propio y unas balas propias para hacer la escopeta.
    - Habia cambios fundamentales que haciamos en un nivel que no se aplicaban en el resto.
      Para arreglar esto, hicimos la escena "levelMaker" e "intermissionMaker", que serian la base de todos los niveles e intermissions.
    - Todos los zombies dejaban la misma sangre al morir y tenian el mismo sonido.
      Metimos funciones para randomizar los sonidos de los zombies y que manchas dejaban en el suelo.
    - Los enemigos te seguian aunque hubiera una pared en medio.
      Metimos un raycast para detectar si habia una pared. Si el raycast da positivo, el zombie no te sigue.
    - La bala tenía una rotación erronea. Para arreglar esto, le cambiamos la rotación en su escena dedicada.
    - Los enemigos seguian persiguiendote aun despues de matarlo.
      Añadimos un bool "dead" a los enemigos para que bajara la velocidad a 0 cuando era true.
    - Los enemigos seguian atacando aun muertos. Despues de hacer que se quedaran estáticos, pusimos que tambien dejaran de hacer daño.
    - Podias disparar con el aumento de vision. Arreglando la lógica de canShoot entre elementos arreglamos el error.
    - La pistola necesitaba balas infinitas. Para poner balas infinitas, metimos la propiedad "usesAmmo" para que no gastara.
    - No se veian las balas infinitas en el contador.
      Para esto, metimos una condicion en la UI para que sacara "INF" en el contador si el cargador de balas estaba a -1.
    - El jugador se desplazaba más rapido en diagonal. 
      Con la función de Godot "normalized()" sacamos la dirección del vector y lo multiplicamos por la velocidad para arreglarlo.
    - El cambio de arma estaba roto.
      Hicimos el método "removePreviousWeapon()" para borrar el arma anterior al meter una nueva.
    - La nueva arma cogida del suelo no disparaba. Solo necesitaba que al cambiar de arma, "canShoot" estuviera en true.

# Que hemos aprendido
Con este proyecto, hemos aprendido:

    - Como utilizar una nueva tecnología no vista en clase (en este caso Godot Engine).
    - Como se desarrollan los videojuegos en 2D.
    - Como se crean los escenarios de los videojuegos 2D.
    - Como funcionan las interfaces dentro de los videojuegos.
    - Un nuevo lenguaje de programación (GDScript).
    - Como aplicar los conocimientos de programación adquiridos en clase a un lenguaje nuevo.
    - A utilizar Git y GitHub con proyectos reales.
    - A optimizar recursos para mejorar el espacio y el rendimiento de un proyecto.
      
