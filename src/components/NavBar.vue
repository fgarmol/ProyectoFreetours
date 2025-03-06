<script setup>
import { ref } from 'vue';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';

const props = defineProps({
    datos: Object,
});

function closeMenu() {
    const navbarCollapse = document.getElementById('navbarSupportedContent');
    const bsCollapse = new bootstrap.Collapse(navbarCollapse, {
        toggle: false
    });
    bsCollapse.hide();
}
</script>

<template>
    <nav class="navbar navbar-expand-lg navbar-dark bg-custom">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav m-auto">
                <li class="nav-item">
                    <RouterLink class="nav-link" to="/" @click="closeMenu">Home</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol != 'guia'">
                    <RouterLink class="nav-link" to="/tus-reservas" @click="closeMenu">Mis Reservas</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'guia'">
                    <RouterLink class="nav-link" to="/guia/rutas" @click="closeMenu">Rutas Asignadas</RouterLink>
                </li>
                    
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'admin'">
                    <div class="dropdown">
                        <button class="nav-link dropdown-toggle" type="button" id="dropdownMenuButton"
                            data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Admin
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <RouterLink class="dropdown-item" to="/admin" @click="closeMenu">Usuarios</RouterLink>
                            <RouterLink class="dropdown-item" to="/admin/rutas" @click="closeMenu">Rutas</RouterLink>
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
    color: white;
    font-weight: bolder;
}

.nav-link.active {
    font-size: larger;
}

.dropdown-menu, .dropdown-item {
    border-radius: 5px;
    padding-bottom: 5%;
    
    color: white;
    background-color: black;
    
    
}

.dropdown-menu .dropdown-item:hover {
    font-weight: bold;
    background-color: white; 
    color: black !important;
}

.dropdown-menu{
    padding-top: 0;
    padding-bottom: 0;
}
</style>