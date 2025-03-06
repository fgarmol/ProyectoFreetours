<template>
    <footer class="footer">
      <p>&copy; {{ new Date().getFullYear() }} - Todos los derechos reservados.</p>
    </footer>
  </template>
  
  <style scoped>
  .footer {
    background: black;
    color: white;
    padding: 1rem;
    text-align: center;
    /* position: fixed; */
    bottom: 0;
    width: 100%;
    z-index: 1000;
  }
  </style>
  