<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';

const props = defineProps({
    datos: Object,
});

const activeRoute = ref('');
const router = useRouter();

function closeMenu(route) {
    activeRoute.value = route;
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
                    <RouterLink class="nav-link" :class="{ active: activeRoute === '/' }" to="/"
                        @click="closeMenu('/')">Home</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado">
                    <RouterLink class="nav-link" :class="{ active: activeRoute === '/tus-reservas' }" to="/tus-reservas"
                        @click="closeMenu('/tus-reservas')">Mis Reservas</RouterLink>
                </li>
                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'guia'">
                    <RouterLink class="nav-link" :class="{ active: activeRoute === '/guia/rutas' }" to="/guia/rutas"
                        @click="closeMenu('/guia/rutas')">Rutas Asignadas</RouterLink>
                </li>

                <li class="nav-item" v-if="datos?.autenticado && datos?.usuario.rol == 'admin'">
                    <div class="dropdown">
                        <button class="nav-link dropdown-toggle" type="button" id="dropdownMenuButton"
                            data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            Admin
                        </button>
                        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <RouterLink class="dropdown-item" to="/admin" @click="closeMenu('/admin')">Usuarios
                            </RouterLink>
                            <RouterLink class="dropdown-item" to="/admin/rutas" @click="closeMenu('/admin/rutas')">Rutas
                            </RouterLink>
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
    font-weight: bold;
}

.dropdown-menu,
.dropdown-item {
    border-radius: 5px;
    padding-bottom: 5%;

    color: white;
    background-color: black;
}

.dropdown-menu .dropdown-item:hover {
    font-weight: bold;
    background-color: white;
    color: black !important;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    /* Efecto de sombra */
    transform: scale(1.05);
    /* Transición de escala */
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    /* Transición suave */
}

.dropdown-menu {
    padding-top: 0;
    padding-bottom: 0;
}

.dropdown-item.active {
    font-weight: bold;
    background-color: white;
    color: black !important;
}
</style>