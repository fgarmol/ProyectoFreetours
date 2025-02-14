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
('Ruta Histórica', 'Madrid', 'Visita por lugares emblemáticos.', 'historia.jpg', '2025-02-10', '10:00', 40.4168, -3.7038),
('Ruta Cultural', 'Sevilla', 'Recorrido por el casco antiguo.', 'cultura.jpg', '2025-02-12', '16:00', 37.3891, -5.9845),
('Ruta Gastronómica', 'Barcelona', 'Descubre los sabores locales.', 'gastronomia.jpg', '2025-02-10', '12:00', 41.3874, 2.1686),
('Ruta de Tapas', 'Madrid', 'Un paseo por los mejores bares de tapas.', 'tapas.jpg', '2025-02-10', '19:00', 40.4168, -3.7038),
('Ruta Monumental', 'Granada', 'Explora la Alhambra y sus alrededores.', 'monumentos.jpg', '2025-02-12', '09:00', 37.1773, -3.5986),
('Ruta del Arte', 'Sevilla', 'Visita museos y galerías.', 'arte.jpg', '2025-02-12', '14:30', 37.3891, -5.9845),
('Ruta Nocturna', 'Valencia', 'Descubre la ciudad iluminada.', 'nocturna.jpg', '2025-02-14', '21:00', 39.4699, -0.3763),
('Ruta Medieval', 'Toledo', 'Explora la historia medieval de la ciudad.', 'medieval.jpg', '2025-02-14', '11:00', 39.8628, -4.0273),
('Ruta Costera', 'Málaga', 'Disfruta del paseo marítimo.', 'costera.jpg', '2025-02-16', '17:00', 36.7213, -4.4212),
('Ruta Modernista', 'Barcelona', 'Explora el legado de Gaudí.', 'modernismo.jpg', '2025-02-16', '10:30', 41.3874, 2.1686),
('Ruta Natural', 'Bilbao', 'Explora los montes cercanos.', 'naturaleza.jpg', '2025-02-18', '08:00', 43.2630, -2.9340),
('Ruta del Mar', 'San Sebastián', 'Paseo por la bahía de la Concha.', 'mar.jpg', '2025-02-18', '15:00', 43.3183, -1.9812),
('Ruta del Vino', 'La Rioja', 'Visita a bodegas con cata de vinos.', 'vino.jpg', '2025-02-20', '13:00', 42.2871, -2.5396),
('Ruta de la Catedral', 'Burgos', 'Descubre la Catedral de Burgos y su historia.', 'catedral.jpg', '2025-02-20', '09:30', 42.3439, -3.6969),
('Ruta de las Murallas', 'Ávila', 'Recorre la ciudad amurallada.', 'murallas.jpg', '2025-02-22', '11:00', 40.6565, -4.7003),
('Ruta Renacentista', 'Salamanca', 'Arquitectura y cultura renacentista.', 'renacimiento.jpg', '2025-02-22', '16:00', 40.9688, -5.6639),
('Ruta del Flamenco', 'Sevilla', 'Vive el auténtico flamenco andaluz.', 'flamenco.jpg', '2025-02-24', '20:00', 37.3891, -5.9845),
('Ruta del Puerto', 'Cádiz', 'Paseo marítimo y gastronomía.', 'puerto.jpg', '2025-02-24', '13:00', 36.5297, -6.2923),
('Ruta Barroca', 'Zaragoza', 'Arquitectura barroca y calles históricas.', 'barroco.jpg', '2025-02-26', '10:00', 41.6488, -0.8891),
('Ruta de los Castillos', 'Segovia', 'Visita al Alcázar y otros castillos.', 'castillos.jpg', '2025-02-26', '14:00', 40.9429, -4.1088),
('Ruta Científica', 'Valencia', 'Ciudad de las Artes y las Ciencias.', 'ciencia.jpg', '2025-02-28', '11:30', 39.4699, -0.3763),
('Ruta del Mercado', 'Barcelona', 'Explora los mercados más icónicos.', 'mercado.jpg', '2025-02-28', '17:30', 41.3874, 2.1686),
('Ruta del Agua', 'Granada', 'Aljibes y fuentes históricas.', 'agua.jpg', '2025-03-02', '09:00', 37.1773, -3.5986),
('Ruta del Parque', 'Madrid', 'Recorrido por el Retiro y otros parques.', 'parque.jpg', '2025-03-02', '16:00', 40.4168, -3.7038),
('Ruta Alternativa', 'Bilbao', 'Descubre el arte urbano y rincones especiales.', 'alternativa.jpg', '2025-03-04', '10:00', 43.2630, -2.9340),
('Ruta de los Puentes', 'Toledo', 'Descubre los puentes históricos.', 'puentes.jpg', '2025-03-04', '15:00', 39.8628, -4.0273);




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
