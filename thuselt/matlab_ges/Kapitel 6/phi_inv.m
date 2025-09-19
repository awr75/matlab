function phi_inv = phi_inv(NA, ni_0, kT)
% Berechnung der Schwellenspannung für einen MOSFET in meV
% NA = Akzeptorkonzentration
% ni_0 = intrinsische Ladungsträgerkonzentraion 

phi_inv = 2* kT * log(NA/ni_0);
% Ergebnis in eV