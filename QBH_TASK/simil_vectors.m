function M = simil_vectors(R1_f,R2_f)
La = length(R1_f);
Lb = length(R2_f);
M = zeros(La,Lb);
for i=1:La
    M(i,:)=abs(R1_f(i)-R2_f);
end
end

