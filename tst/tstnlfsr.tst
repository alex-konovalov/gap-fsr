gap> F := GF(2);; B:= Basis(F);; ChooseField(F);; seq :=[];;
You can now create an NLFSR with up to 100 stages
with up to  100 nonzero terms
gap> clist := [One(F), One(F)];;
gap> mlist := [x_0*x_1, x_2];;
gap> nl := NLFSR(F, clist, mlist, 3);
< empty NLFSR of length 3,
 given by MultivarPoly = x_0*x_1+x_2>
gap> ist := [One(F),Zero(F),Zero(F)];; LoadFSR(nl,ist);;
gap> PrintAll(nl);
< NLFSR of length 3 over GF(2),
 given by MultivarPoly = x_0*x_1+x_2> with feedback coeff =[ Z(2)^0, Z(2)^0 ]
with initial state  =[ Z(2)^0, 0*Z(2), 0*Z(2) ]
with current state  =[ Z(2)^0, 0*Z(2), 0*Z(2) ]
after loading
with output from stage S_0
gap> FieldPoly(nl); UnderlyingField(nl); FeedbackVec(nl); OutputTap(nl);
1
GF(2)
[ Z(2)^0, Z(2)^0 ]
[ 0 ]
gap> MultivarPoly(nl); IndetList(nl);  
x_0*x_1+x_2
[ 0, 1, 2 ]
gap> RunFSR(nl);                        
[ 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0 ]
gap>  LoadFSR(nl, ist);; RunFSR(nl,5);
[ 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ]
gap>  LoadFSR(nl, ist);;B := Basis(UnderlyingField(nl));; RunFSR(nl,B, 5,true);
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ]
gap> RunFSR(nl, B, true);
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0 ]
gap>  LoadFSR(nl, ist);; RunFSR(nl);  
[ 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0 ]
gap> LoadFSR(nl, ist);; RunFSR(nl, B, ist, 40, true);
using basis B := [ Z(2)^0 ]	
elm 		[ 2,...,0 ]  with taps  [ 0 ]
 		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
over the threshold, will only output the first 11 elements of the sequence
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0 ]
gap>  RunFSR(nl, B, ist, 10, true); 
using basis B := [ Z(2)^0 ]	
elm 		[ 2,...,0 ]  with taps  [ 0 ]
 		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ]
gap>  RunFSR(nl, ist, 10);
[ 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2) ]
gap>  RunFSR(nl, ist);    
[ 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0 ]
gap> RunFSR(nl, B, ist, true); 
using basis B := [ Z(2)^0 ]	
elm 		[ 2,...,0 ]  with taps  [ 0 ]
 		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 1 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 1 ], [ 1 ] ]		[ 1 ]
[ 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0 ]
gap> LoadFSR(nl, ist);; elm := Z(2)^0;; RunFSR(nl, B, elm, 10, true); 
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0 ]
gap>  LoadFSR(nl, ist);; elm := Z(2)^0;; RunFSR(nl, elm, 10); 
[ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0 ]
gap> LoadFSR(nl, ist);; elm := Z(2)^0;; RunFSR(nl, B, elm, true); 
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2) ]
gap>  elmvec := [Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0];;
gap>  RunFSR(nl, B, ist, elmvec, true);
elm 		[ 2,...,0 ]  with taps  [ 0 ]
 		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
[ 1 ]		[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 0 ]		[ [ 0 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ 1 ]		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
[ 1 ]		[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 0 ]		[ [ 0 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ 1 ]		[ [ 1 ], [ 0 ], [ 0 ] ]		[ 0 ]
[ 1 ]		[ [ 0 ], [ 1 ], [ 0 ] ]		[ 0 ]
[ 1 ]		[ [ 1 ], [ 0 ], [ 1 ] ]		[ 1 ]
[ Z(2)^0, 0*Z(2), Z(2)^0, 0*Z(2), 0*Z(2), Z(2)^0, 0*Z(2), 0*Z(2), Z(2)^0 ]
gap> clist := [One(F), One(F), One(F), One(F)];;
gap> mlist := [x_0, x_1, x_1*x_2*x_3, One(F)];;
gap> nl := NLFSR(F, clist, mlist, 4);
< empty NLFSR of length 4,
 given by MultivarPoly = x_1*x_2*x_3+x_0+x_1+Z(2)^0> 
gap> ist := [Zero(F),Zero(F),Zero(F),Zero(F)];; RunFSR(nl,ist);
[ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2), Z(2)^0, Z(2)^0, Z(2)^0, Z(2)^0, 0*Z(2), Z(2)^0, Z(2)^0, 0*Z(2), 0*Z(2), Z(2)^0, 
  0*Z(2), Z(2)^0, 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ]
gap> K := GF(2);; x := X(K, "x");; f:= x^4+x^3+Z(2)^0 ;;  F := FieldExtension(K, f);;                               
gap>  B:= Basis(F);; ChooseField(F);; seq :=[];;
You can now create an NLFSR with up to 100 stages
with up to  100 nonzero terms
gap> clist := [Z(2^4)^7, One(F), One(F), One(F)];;
gap> mlist := [x_0, x_1^5, x_1*x_2*x_3, One(F)];;
gap> nl := NLFSR(F, clist, mlist, 4);
< empty NLFSR of length 4,
 given by MultivarPoly = x_1^5+x_1*x_2*x_3+Z(2^4)^7*x_0+Z(2)^0> 
gap> nl := NLFSR(K, f,  clist, mlist, 4);
< empty NLFSR of length 4,
 given by MultivarPoly = x_1^5+x_1*x_2*x_3+Z(2^4)^7*x_0+Z(2)^0> 
gap> nl := NLFSR(K, f,  clist, mlist, 4, 2);
< empty NLFSR of length 4,
 given by MultivarPoly = x_1^5+x_1*x_2*x_3+Z(2^4)^7*x_0+Z(2)^0> 
gap> PrintAll(nl);
< empty NLFSR of length 4,
 given by MultivarPoly = x_1^5+x_1*x_2*x_3+Z(2^4)^7*x_0+Z(2)^0> with feedback coeff =
[ Z(2^4)^7, Z(2)^0, Z(2)^0, Z(2)^0 ]
with initial state  =[ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ]
with current state  =[ 0*Z(2), 0*Z(2), 0*Z(2), 0*Z(2) ]
after initialization 
with output from stage S_2





