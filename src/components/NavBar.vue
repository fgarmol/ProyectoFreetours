<script setup>
import { ref } from 'vue';

defineProps({
    datos: Object
});

</script>

<template>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
<!--         <a class="navbar-brand" href="#">Menu</a>
 -->        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav m-auto">
                <!-- <li v-if="datos?.rol == 'profe'" class="nav-item active">
                    <a class="nav-link" href="#">Preguntas </a>
                </li>
                <li v-if="datos?.rol == 'profe'" class="nav-item">
                    <a class="nav-link" href="#">Categorias</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Examenes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Resultados</a>
                </li> -->
                <li class="nav-link">
                <RouterLink class="nav-link" to="/">Home</RouterLink>
            </li>
            <li class="nav-link">
                <RouterLink class="nav-link" to="/login">Login</RouterLink>
            </li>
            <li class="nav-link">
                <RouterLink class="nav-link" to="/admin">admin</RouterLink>
            </li>
            </ul>
           
        </div>
    </nav>
</template>
<style scooped>
.item{
    color: green;
}
</style>