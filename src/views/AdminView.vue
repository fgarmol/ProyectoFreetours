<script setup>
import { ref } from 'vue';
//funcion para obtener todos los usuarios de la api  y mostrarlos en la tabla
async function cargarUsuarios() {
    

    fetch("http://localhost/APIFreetours/api.php/usuarios")
        .then(response => {
          if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
          }
          return response.json();
        })
        .then(data => {

            console.log(data);
            data.forEach(usuario => {
                console.log(usuario);
            

          });
        })
        .catch(error => showAlert(`Error al obtener usuarios: ${error.message}`));
   
}

</script>

<template>


    
</template>