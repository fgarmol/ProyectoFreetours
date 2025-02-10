<script setup>
import { ref } from 'vue';

const props = defineProps({
    datos: Object,
    
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
                <li class="nav-link">
                <RouterLink class="nav-link" to="/">Home</RouterLink>
            </li>
            <li class="nav-link">
                <RouterLink class="nav-link" to="/login">Login</RouterLink>
            </li>
            <!-- se mostrará la seccion de Admin si el rol del usuario es Admin -->
            <li class="nav-link" v-if="datos?.autenticado && datos?.usuario.rol =='admin'">
                <RouterLink class="nav-link" to="/admin">Admin</RouterLink>
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