<script setup>
import { ref } from 'vue';
import bootstrapBundle from 'bootstrap/dist/js/bootstrap.bundle';

const props = defineProps({
    datos: Object,
});
</script>

<template>
    <nav class="navbar navbar-expand-lg navbar-dark bg-custom">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav m-auto">
                <li class="nav-item">
                    <RouterLink class="nav-link" to="/">Home</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol != 'guia'">
                    <RouterLink class="nav-link" to="/tus-reservas">Mis Reservas</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'guia'">
                    <RouterLink class="nav-link" to="/guia/rutas">Rutas Asignadas</RouterLink>
                </li>
                    
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'admin'">
                    <div class="dropdown">
                        <button class="nav-link dropdown-toggle" type="button" id="dropdownMenuButton"
                            data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Admin
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <RouterLink class="dropdown-item" to="/admin">Usuarios</RouterLink>
                            <RouterLink class="dropdown-item" to="/admin/rutas">Rutas</RouterLink>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
</template>

<style scoped>


    

.navbar.bg-custom {
    background-color: black; 
}

.nav-link {
    color: white;
     
}

.nav-link:hover {
    color:white;
    font-weight: bolder;
}

.nav-link.active {
    font-size: larger;
     
}

.dropdown-menu .dropdown-item {
    color: var(--color-texto-principal) !important; /* Negro */
}

.dropdown-menu .dropdown-item:hover {
    background-color: var(--color-secundario-1) !important; /* Amarillo Dorado */
    color: var(--color-texto-principal) !important; /* Negro */
}
</style>