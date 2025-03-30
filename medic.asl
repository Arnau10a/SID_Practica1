+flag (F): team(200)
  <-
  +flag_position(F);
  .register_service("medic");
  .print("Médico AXIS iniciando defensa de la bandera");
  .goto(F);
  .wait(2000);
  .cure;
  !create_medicine_regularly.

+target_reached(T): team(200)
  <-
  .print("He llegado a la bandera, vigilando y curando");
  .cure;
  .turn(0.375);
  .wait(1500);
  +defending;
  -target_reached(T).

+defending: team(200)
  <-
  .turn(0.375);
  .wait(1500);
  .cure;
  +defending.

+msg(Sender, tell, saveme): team(200)
  <-
  .print("Solicitud de ayuda recibida de ", Sender);
  -defending;
  +helping;
  .send(Sender, tell, coming);
  .goto(Sender).

+target_reached(T): helping & team(200)
  <-
  .print("He llegado al aliado herido");
  .cure;
  .cure;
  .wait(1000);
  -helping;
  ?flag_position(F);
  .goto(F);
  -target_reached(T).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(200)
  <-
  .print("¡Enemigo detectado! Atacando al enemigo");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !attack_enemy.

+!attack_enemy: team(200) & enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Continuando ataque al enemigo");
  .look_at(Position);
  .shoot(3, Position);
  .wait(500);
  !attack_enemy.

+!attack_enemy: team(200) & not enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .print("Enemigo eliminado o fuera de vista, volviendo a vigilar");
  ?flag_position(F);
  .goto(F);
  +defending.

+!create_medicine_regularly: team(200)
  <-
  .wait(15000);
  .cure;
  .print("Creando paquete de medicina periódico");
  !create_medicine_regularly.

+flag (F): team(100)
  <-
  .print("Médico ALLIED iniciando misión de captura");
  .register_service("medic");
  +objective(F);
  +supporting;
  !follow_soldiers.

+!follow_soldiers: team(100)
  <-
  .get_backups;
  ?objective(F);
  .goto(F);
  .print("Siguiendo a los soldados hacia el objetivo").

+target_reached(T): team(100) & objective(F)
  <-
  .print("He llegado al objetivo");
  .cure;
  .turn(0.375);
  .wait(1000);
  +exploring;
  -target_reached(T).

+heading(H): exploring & team(100)
  <-
  .wait(2000);
  .turn(0.375);
  .cure.

+msg(Sender, tell, low_health): team(100)
  <-
  .print("Aliado con salud baja detectado");
  -exploring;
  +helping;
  +ally_to_help(Sender);
  .send(Sender, tell, coming);
  !go_to_ally.

+!go_to_ally: ally_to_help(Ally) & team(100)
  <-
  .print("Yendo a ayudar a aliado herido");
  .goto(Ally).

+target_reached(T): helping & team(100)
  <-
  .print("Llegué al aliado herido");
  .cure;
  .cure;
  .wait(1000);
  -helping;
  -ally_to_help(_);
  +supporting;
  !follow_soldiers;
  -target_reached(T).

+flag_taken: team(100)
  <-
  .print("¡Bandera capturada! Dando apoyo al portador");
  -exploring;
  +escorting;
  .get_backups;
  !escort_flag_carrier.

+!escort_flag_carrier: team(100)
  <-
  .print("Escoltando al portador de la bandera");
  ?base(B);
  .goto(B);
  .cure;
  .wait(3000);
  !escort_flag_carrier.

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): team(100)
  <-
  .print("Enemigo detectado, dejando medicina y buscando cobertura");
  .cure;
  .get_backups;
  !take_cover.

+!take_cover: team(100)
  <-
  .print("Buscando cobertura contra enemigos");
  ?base(B);
  .goto(B);
  .wait(2000);
  !follow_soldiers.

+health(H): H < 30
  <-
  .print("¡Salud crítica! Auto-sanándome");
  .cure;
  !take_cover.
