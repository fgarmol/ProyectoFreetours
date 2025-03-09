USE free_tours;

-- Insertar Usuarios (Administrador, Guías, Clientes)
INSERT INTO usuarios (nombre, email, contraseña, rol) VALUES
('Admin', 'admin@tours.com', 'admin123', 'admin'),
('Guía 1', 'guia1@tours.com', 'pass123', 'guia'),
('Guía 2', 'guia2@tours.com', 'pass123', 'guia'),
('Cliente 1', 'cliente1@tours.com', 'pass123', 'cliente'),
('Cliente 2', 'cliente2@tours.com', 'pass123', 'cliente');

-- Insertar Rutas
INSERT INTO rutas (titulo, localidad, descripcion, foto, fecha, hora, latitud, longitud) VALUES
('Ruta Histórica', 'Madrid', 'Visita por lugares emblemáticos.', 'https://picsum.photos/265/190?random=1', '2025-02-10', '10:00', 40.4168, -3.7038),
('Ruta Natural', 'Barcelona', 'Senderismo por paisajes naturales.', 'https://picsum.photos/265/190?random=2', '2025-02-11', '09:00', 41.3784, 2.1915),
('Ruta Cultural', 'Sevilla', 'Recorrido por monumentos históricos.', 'https://picsum.photos/265/190?random=3', '2025-02-12', '11:00', 37.3886, -5.9823),
('Ruta Gastronómica', 'Valencia', 'Tour de tapas y platos típicos.', 'https://picsum.photos/265/190?random=4', '2025-02-13', '13:00', 39.4699, -0.3763),
('Ruta de Senderismo', 'Granada', 'Caminata por la Alpujarra.', 'https://picsum.photos/265/190?random=5', '2025-02-14', '08:00', 37.1773, -3.5986),
('Ruta de Arte', 'Bilbao', 'Visita a museos y galerías.', 'https://picsum.photos/265/190?random=6', '2025-02-15', '10:00', 43.2630, -2.9340),
('Ruta de Compras', 'Madrid', 'Tour por tiendas de lujo.', 'https://picsum.photos/265/190?random=7', '2025-02-16', '12:00', 40.4168, -3.7038),
('Ruta de Aventura', 'Barcelona', 'Actividades extremas en la naturaleza.', 'https://picsum.photos/265/190?random=8', '2025-02-17', '14:00', 41.3784, 2.1915),
('Ruta Histórica', 'Sevilla', 'Recorrido por monumentos históricos.', 'https://picsum.photos/265/190?random=9', '2025-02-18', '10:00', 37.3886, -5.9823),
('Ruta Natural', 'Valencia', 'Senderismo por paisajes naturales.', 'https://picsum.photos/265/190?random=10', '2025-02-19', '09:00', 39.4699, -0.3763),
('Ruta Cultural', 'Granada', 'Visita a monumentos históricos.', 'https://picsum.photos/265/190?random=11', '2025-02-20', '11:00', 37.1773, -3.5986),
('Ruta Gastronómica', 'Bilbao', 'Tour de pintxos y platos típicos.', 'https://picsum.photos/265/190?random=12', '2025-02-21', '13:00', 43.2630, -2.9340),
('Ruta de Senderismo', 'Madrid', 'Caminata por la Sierra de Guadarrama.', 'https://picsum.photos/265/190?random=13', '2025-02-22', '08:00', 40.4168, -3.7038),
('Ruta de Arte', 'Barcelona', 'Visita a museos y galerías de arte.', 'https://picsum.photos/265/190?random=14', '2025-02-23', '10:00', 41.3784, 2.1915),
('Ruta de Compras', 'Sevilla', 'Tour por tiendas de artesanía local.', 'https://picsum.photos/265/190?random=15', '2025-02-24', '12:00', 37.3886, -5.9823),
('Ruta de Aventura', 'Valencia', 'Actividades acuáticas en la costa.', 'https://picsum.photos/265/190?random=16', '2025-02-25', '14:00', 39.4699, -0.3763),
('Ruta Histórica', 'Granada', 'Recorrido por la Alhambra y alrededores.', 'https://picsum.photos/265/190?random=17', '2025-02-26', '10:00', 37, -7.3234),
('Ruta Natural', 'Madrid', 'Senderismo por la Sierra de Guadarrama.', 'https://picsum.photos/265/190?random=18', '2025-02-27', '09:00', 40.4168, -3.7038),
('Ruta Cultural', 'Barcelona', 'Recorrido por la historia y cultura local.', 'https://picsum.photos/265/190?random=19', '2025-02-28', '11:00', 41.3784, 2.1915),
('Ruta Gastronómica', 'Sevilla', 'Tour gastronómico por la ciudad.', 'https://picsum.photos/265/190?random=20', '2025-03-01', '13:00', 37.3886, -5.9823),
('Ruta de Senderismo', 'Valencia', 'Senderismo por parques naturales.', 'https://picsum.photos/265/190?random=21', '2025-03-02', '08:00', 39.4699, -0.3763),
('Ruta de Arte', 'Granada', 'Visita a la Alhambra y museos locales.', 'https://picsum.photos/265/190?random=22', '2025-03-03', '10:00', 37.1773, -3.5986),
('Ruta de Compras', 'Bilbao', 'Recorrido por tiendas de diseño local.', 'https://picsum.photos/265/190?random=23', '2025-03-04', '12:00', 43.2630, -2.9340),
('Ruta de Aventura', 'Madrid', 'Actividades al aire libre en la naturaleza.', 'https://picsum.photos/265/190?random=24', '2025-03-05', '14:00', 40.4168, -3.7038),
('Ruta Histórica', 'Barcelona', 'Recorrido por barrios con historia.', 'https://picsum.photos/265/190?random=25', '2025-03-06', '10:00', 41.3784, 2.1915),
('Ruta Natural', 'Sevilla', 'Senderismo en los alrededores de la ciudad.', 'https://picsum.photos/265/190?random=26', '2025-03-07', '09:00', 37.3886, -5.9823),
('Ruta Cultural', 'Valencia', 'Visita a monumentos culturales importantes.', 'https://picsum.photos/265/190?random=27', '2025-03-08', '11:00', 39.4699, -0.3763),
('Ruta Gastronómica', 'Granada', 'Cata de platos típicos locales.', 'https://picsum.photos/265/190?random=28', '2025-03-09', '13:00', 37.1773, -3.5986),
('Ruta de Senderismo', 'Bilbao', 'Ruta por las montañas cercanas.', 'https://picsum.photos/265/190?random=29', '2025-03-10', '08:00', 43.2630, -2.9340),
('Ruta de Arte', 'Madrid', 'Visita a museos y centros culturales.', 'https://picsum.photos/265/190?random=30', '2025-03-11', '10:00', 40.4168, -3.7038),
('Ruta de Compras', 'Barcelona', 'Tour por boutiques de moda.', 'https://picsum.photos/265/190?random=31', '2025-03-12', '12:00', 41.3784, 2.1915),
('Ruta de Aventura', 'Sevilla', 'Actividades en parques naturales.', 'https://picsum.photos/265/190?random=32', '2025-03-13', '14:00', 37.3886, -5.9823),
('Ruta Histórica', 'Valencia', 'Recorrido por la historia de la ciudad.', 'https://picsum.photos/265/190?random=33', '2025-03-14', '10:00', 39.4699, -0.3763),
('Ruta Natural', 'Granada', 'Senderismo por los parques naturales.', 'https://picsum.photos/265/190?random=34', '2025-03-15', '09:00', 37.1773, -3.5986),
('Ruta Cultural', 'Bilbao', 'Visita a la historia de la ciudad.', 'https://picsum.photos/265/190?random=35', '2025-03-16', '11:00', 43.2630, -2.9340),
('Ruta Gastronómica', 'Madrid', 'Tour gastronómico por mercados locales.', 'https://picsum.photos/265/190?random=36', '2025-03-17', '13:00', 40.4168, -3.7038),
('Ruta de Senderismo', 'Barcelona', 'Recorrido por montañas cercanas.', 'https://picsum.photos/265/190?random=37', '2025-03-18', '08:00', 41.3784, 2.1915),
('Ruta de Arte', 'Sevilla', 'Visita a exposiciones de arte local.', 'https://picsum.photos/265/190?random=38', '2025-03-19', '10:00', 37.3886, -5.9823),
('Ruta de Compras', 'Valencia', 'Shopping en las mejores tiendas de la ciudad.', 'https://picsum.photos/265/190?random=39', '2025-03-20', '12:00', 39.4699, -0.3763),
('Ruta de Aventura', 'Granada', 'Recorrido por rutas de aventura al aire libre.', 'https://picsum.photos/265/190?random=40', '2025-03-21', '14:00', 37.1773, -3.5986),
('Ruta Histórica', 'Bilbao', 'Visita a lugares históricos de la ciudad.', 'https://picsum.photos/265/190?random=41', '2025-03-22', '10:00', 43.2630, -2.9340),
('Ruta Natural', 'Madrid', 'Senderismo por el campo cercano a la ciudad.', 'https://picsum.photos/265/190?random=42', '2025-03-23', '09:00', 40.4168, -3.7038),
('Ruta Cultural', 'Barcelona', 'Recorrido por el arte y la arquitectura de la ciudad.', 'https://picsum.photos/265/190?random=43', '2025-03-24', '11:00', 41.3784, 2.1915),
('Ruta Gastronómica', 'Sevilla', 'Tour de tapas en el centro histórico.', 'https://picsum.photos/265/190?random=44', '2025-03-25', '13:00', 37.3886, -5.9823),
('Ruta de Senderismo', 'Valencia', 'Rutas por la naturaleza mediterránea.', 'https://picsum.photos/265/190?random=45', '2025-03-26', '08:00', 39.4699, -0.3763),
('Ruta de Arte', 'Granada', 'Exploración de la cultura granadina.', 'https://picsum.photos/265/190?random=46', '2025-03-27', '10:00', 37.1773, -3.5986),
('Ruta de Compras', 'Bilbao', 'Visita a las tiendas locales de la ciudad.', 'https://picsum.photos/265/190?random=47', '2025-03-28', '12:00', 43.2630, -2.9340),
('Ruta de Aventura', 'Madrid', 'Actividades de aventura en el entorno natural.', 'https://picsum.photos/265/190?random=48', '2025-03-29', '14:00', 40.4168, -3.7038),
('Ruta Histórica', 'Barcelona', 'Recorrido por monumentos y edificios históricos.', 'https://picsum.photos/265/190?random=49', '2025-03-30', '10:00', 41.3784, 2.1915),
('Ruta Natural', 'Sevilla', 'Senderismo por el Parque Natural.', 'https://picsum.photos/265/190?random=50', '2025-03-31', '09:00', 37.3886, -5.9823);

 



-- Insertar Asignaciones de Guías a Rutas
INSERT INTO asignaciones (ruta_id, guia_id) VALUES
(1, 2), -- Guía 2 asignado a la Ruta 1
(2, 3); -- Guía 3 asignado a la Ruta 2

-- Insertar Reservas de Clientes
INSERT INTO reservas (ruta_id, cliente_id, num_personas) VALUES
(1, 4, 2), -- Cliente 1 reservó para 2 personas en la Ruta 1
(2, 5, 3); -- Cliente 2 reservó para 3 personas en la Ruta 2

-- Insertar Valoraciones de Rutas
INSERT INTO valoraciones (ruta_id, cliente_id, puntuacion, comentario) VALUES
(1, 4, 5, 'Excelente recorrido, muy informativo!'),
(2, 5, 4, 'Muy interesante, pero un poco largo.');
