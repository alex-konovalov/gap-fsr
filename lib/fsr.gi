#############################################################################
##
#W  fsr.gi                   GAP Package                   nusa zidaric
##
##

#############################################################################
##
#F  ChooseField( <F> )
##
##  choose the underlying finite field for the NLFSR
##  needed to create the indeterminates !!!!
##  :(
## ugly, take a second look at it !!!!
##
InstallGlobalFunction( ChooseField, function( F )
    local x, i , str, MaxNLFSRLen, MaxNrOfPresentMonomials, xlist ;

	if(IsField(F)) then
		x := X(F, "x");
		MaxNLFSRLen := 100;
		MaxNrOfPresentMonomials := 100;
		if not IsBoundGlobal("MaxNLFSRLen") then 
			BindGlobal("MaxNLFSRLen" , 100);
			BindGlobal("MaxNrOfPresentMonomials" , 100);
			MakeReadWriteGlobal("MaxNLFSRLen");
			MakeReadWriteGlobal("MaxNrOfPresentMonomials");
		fi;

		xlist := [];
		for i in [1..MaxNLFSRLen] do  
			str :=  Concatenation("x_",String(i-1)); 
			if IsBoundGlobal(str) then 
	#			Print("changing: ",str," \n");
				str := Indeterminate(F,1000+(i-1));
			else

	#			Print("binding: ",str," \n");			
				SetIndeterminateName(FamilyObj(x), 800+(i-1), str); 
				BindGlobal(str,Indeterminate(F,800+(i-1)));
				MakeReadWriteGlobal(str);
			fi;
			Add(xlist, str );
		od;
		if not IsBoundGlobal("xlist") then 
			BindGlobal("xlist" , xlist);
		fi;
		Print("You can now create an NLFSR with up to ", MaxNLFSRLen ," stages\n");
		Print("with up to  ", MaxNrOfPresentMonomials ," nonzero terms\n");
	else 	
	    Error("F is not a field !!!! \n");
	  fi;
return;
end );


#############################################################################
##
#F  FSRFamily( <p> ) 
##  copied from FFEFamily :)
##
InstallGlobalFunction( FSRFamily, function( p )
    local fam;
    if MAXSIZE_GF_INTERNAL < p then
       fam:= NewFamily( "FSRFamily", IsFSR );
       SetCharacteristic( fam, p );
    else
      # small characteristic
      fam:= FamilyType( TYPE_FFE( p ) );
    fi;
 #   fam!.FSRType:= NewType( fam, IsFSR );
    return fam;
end );



#############################################################################
##
#A  InternalStateSize( <fsr> )
##  still works after the move :) 
InstallMethod(InternalStateSize, "size of FSR's internal state", [IsFSR], function(x)
local n, poly, s; 
	n := Length(x); 
	poly := FieldPoly(x);

	if poly=1 then 
		s := n;
	else 	s := Degree(poly)*n;
	fi;
	SetInternalStateSize(x,s);
	return s;
end);


#############################################################################
##
#O  LoadFSR( <lfsr>, <ist> )
##
##  almost identical for both 
##
InstallMethod(LoadFSR, "one step of FSR", [IsFSR,  IsFFECollection], function(x, ist)
local i, F, tap, seq, scist;
	if Length(ist) <> Length(x) then
		Error( "initial state length doesnt match" );		return fail;
	fi;
	F := UnderlyingField(x);
	for i in [1..Length(ist)] do 
		if not (\in(ist[i], F)) then
			Error( "initial state element at index=",i,"is not an element of the underlying field !!!" );
					return fail;
		fi;	
	od;	
	
# update fields
	# NOT reversed !!!!
	scist := ShallowCopy((ist)); 	# without this the original ist outside here was changing too :( 
	x!.init := Immutable(scist);
	x!.state := scist;
	x!.numsteps := 0;
	
## TO DO : UPDATE THE BoolState field for NLFSR 
# not having BoolState for NLFSR anymore !!! 
# which makes it the same for LFSR and NLFSR :)
## this TO DO = DONE
	
# sequence starts with seq_0, seq_1, ...
	tap := OutputTap(x); 
	if Length(tap)=1 then 
	#	Print("Length=",Length(x)," and tap =",tap[1]," and index =",Length(x)-tap[1],"\n");
		seq := ist[Length(x)-tap[1]];
	else  # this is rare !!! so dont make seq a list if not necessary
		seq := [];
		for i in [1.. Length(tap)] do  
	 		seq[i] :=  ist[Length(x)-tap[i]]; # to get the corresponding index 
	 	od;
	fi; 

	return seq; #must return first output seq_0, but numsteps=0
end);

#############################################################################
##
#O  StepFSR( <fsr> , <print>)
##



# StepFSR is done for two cases, IsLFSR and IsNLFSR 
# since this is the only one of Load, Step Run functions with the distinction
# its kept here instead of having separate calls for IsLFSR and IsNLFRS
# another reason: its used a lot and having if-else is faster than 
# having a StepFSR(FSR) which would then call StepFSR(LFSR) or StepFSR(NLFSR) 
# also: smaller code in terms of lines of code 


##this one is more commonly used 
## so whats faster: GAP calling the next menthod with elm = 0 
## or having an almost identical copy of the method (difference is only in the computation of new)

InstallMethod(StepFSR, "one step of FSR", [IsFSR], function(x )
local fb, st, new, tap,i, seq, n, F, indlist, xlist, slist, idx; 

	if x!.numsteps < 0 then 
		Error( "the LFSR is NOT loaded !!!" );
				return fail;
	fi;		
	F := UnderlyingField(x);
	n := Length(x);
	fb := FeedbackVec(x); 
	st := x!.state; 

# the step

	
	if IsLFSR(x) then 
		new := fb * st;
	elif IsNLFSR(x) then 
		xlist :=[]; slist :=[];
		indlist := IndetList(x);
		for i in [1.. Length(indlist)] do
			idx := indlist[i];
			Add(xlist,Indeterminate(F,800+idx));
			Add(slist,st[Length(x)-idx]); ## because states are DOWNTO !!! 
		od;
#		Print(xlist,"\n");	
#		Print(slist,"\n");
		
		new := Value(MultivarPoly(x), xlist, slist);	
#		Print("new=",new,"\n");
	else 
		Error("Youre trying to perform StepFSR on something thats neither an LFSR nor NLFSR!!!"); return fail;	
	
	fi;
	
	if not(\in(new,F)) then
		Error( "computed feedback is not an element of the underlying field !!!" );		return fail;
	fi;
	
	
	RightShiftRowVector(st,1,new);	# NOT reversed !!!!  -> hence right shift to get rid of the lowst one
	Remove(st, n+1);
# if we didnt use the downto notation then:
#	LeftShiftRowVector(st,1);
#	st[n] := new;
	


# sequence starts with seq_0, seq_1, ...
	tap := OutputTap(x); 
	if Length(tap)=1 then 
		seq := st[n-tap[1]];
	else  # this is rare !!! so dont make seq a list if not necessary
		seq := [];
		for i in [1.. Length(tap)] do  
	 		seq[i] :=  st[n-tap[i]]; # to get the corresponding index 
	 	od;
	fi; 
	
# update fields
	x!.state := st;
	x!.numsteps := x!.numsteps + 1;
	
	return seq;
end);



InstallMethod(StepFSR, "one step of FSR with an external input", [IsFSR, IsFFE], function(x, elm)
local fb, st, new, tap,i, seq, F, n, idx, indlist, slist, xlist; 
	if x!.numsteps < 0 then 
		Error( "the FSR is NOT loaded !!!" );
		return fail;
	fi;		
	F := UnderlyingField(x);
	if not (\in(elm, F)) then
		Error( "second argument ",elm," is not an element of the underlying field !!!" );
		return fail;
	fi;	

	n := Length(x);
	fb := FeedbackVec(x); 
	st := x!.state; 

# the step
	new := (fb * st) + elm; 
	
	if IsLFSR(x) then 
		new := (fb * st) + elm; 
	elif IsNLFSR(x) then 
		xlist :=[]; slist :=[];
		indlist := IndetList(x);
		for i in [1.. Length(indlist)] do
			idx := indlist[i];
			Add(xlist,Indeterminate(F,800+idx));
			Add(slist,st[Length(x)-idx]); ## because states are DOWNTO !!! 
		od;
#		Print(xlist,"\n");	
#		Print(slist,"\n");
		
		new := Value(MultivarPoly(x), xlist, slist) + elm;	
#		Print("new=",new,"\n");
	else 
		Error("Youre trying to perform StepFSR on something thats neither an LFSR nor NLFSR!!!"); return fail;	
	
	fi;	
	
	
	
	if not(\in(new,F)) then
		Error( "computed feedback is not an element of the underlying field !!!" );		return fail;
	fi;

	RightShiftRowVector(st,1,new);	# NOT reversed !!!!  -> hence right shift to get rid of the lowst one
	Remove(st, n+1);
	

# sequence starts with seq_0, seq_1, ...
	tap := OutputTap(x); 
	if Length(tap)=1 then 
		seq := st[n-tap[1]];
	else  # this is rare !!! so dont make seq a list if not necessary
		seq := [];
		for i in [1.. Length(tap)] do  
	 		seq[i] :=  st[n-tap[i]]; # to get the corresponding index 
	 	od;
	fi; 	
	
# update fields
	x!.state := st;
	x!.numsteps := x!.numsteps + 1;

	return seq;
end);




#############################################################################
##
#O  RunFSR( <FSR> , <num>, <pr> ) ......... I.   run for num steps with/without print to shell
#O  RunFSR( <FSR> , <num> ) ............... II.  run for num steps without print to shell
#O  RunFSR( <FSR> , <pr> ) ................ III. run with/without print to shell
#O  RunFSR( <FSR> ) ....................... IV.  run without print to shell
#O  RunFSR( <FSR> , <ist>, <num>, <pr>) ... V.   load new initial state then run for num-1 steps with/without print to shell
#O  RunFSR( <FSR> , <ist>, <num>) ......... VI.  load new initial state then run for num-1 steps without print to shell
#O  RunFSR( <FSR> , <ist>) ................ VII. load new initial state then run without print to shell
## nonlinear versions 
#O RunFSR(<FSR>, <elm>, <num>, <pr>) ...... VIII. run for num steps with the same nonlinear input on each step and with/without print to shell
#O RunFSR(<FSR>, <elm>, <num> ) ........... IX.   run for num steps with the same nonlinear input on each step without print to shell
#O RunFSR(<FSR>, <elm> ) ........... X.   run for threshold steps with the same nonlinear input on each step without print to shell
#O RunFSR(<FSR>, <ist>, <elmvec>, <pr> ) .. XI.    run for num steps with the different nonlinear input on each step with/without print to shell


# Ib. run for num steps with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis, IsPosInt, IsBool], function(x, B, num, pr)
local seq, sequence, nrsteps, treshold, i, divs; 

# check basis - simple check , only checking if number of basis elms makes sense, 
# not checking if its a lin indep set coz if its not it wont pass tru the IsBasis filter, so we should be fine  
	divs := DivisorsInt(DegreeOverPrimeField(UnderlyingField(x)));
	if not \in(Length(B),divs) then 
		Error("check if youre using correct basis!");
		return fail;
	fi; 
	

# check num
	treshold := 2^Length(x) + Length(x); 
#(if LFSR and primitive thats one period plus one length of FSR + 1)
#(if NLFSR and primitive thats one max possible period plus one length of FSR )
	if num > treshold then 
		Print("over the threshold, will only output the first ",treshold," elements of the sequence\n");
		nrsteps := treshold;
	else 	nrsteps := num;
	fi;

	




#start run
	sequence := [];		
	
	
	for i in [1.. nrsteps] do 
		seq := StepFSR(x);
		Add(sequence, seq); #append at the end of the list: seq_0,seq_1,seq_2, ...
#print on every step 
		if pr then 
			Print("\t\t", IntVecFFExt(B, x!.state));  				# NOT reversed !!!! 
			if 	Length(OutputTap(x))=1 then Print("\t\t", IntFFExt(B,seq) , "\n");
			else  	Print("\t\t",  IntVecFFExt(B, seq) , "\n");
			fi;			
		fi;
	od; 

	return sequence;
end);



# II. run for num steps without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsPosInt], function(x, num)
	return  RunFSR(x, Basis(UnderlyingField(x)), num, false);	
end);


# IIIb. run with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR,  IsBasis,  IsBool], function(x, B, pr)		
	return RunFSR(x, B, 2^Length(x) + Length(x), pr);
end);


# IV. run without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR], function(x)		
	return RunFSR(x, Basis(UnderlyingField(x)), 2^Length(x) + Length(x), false);
end);


# PRIMARY METHOD FOR ALL PRACTICAL PURPOSES: because otherwise u need to handle the seq_0 elm urself 
# load with <ist> then call   RunFSR( FSR, num-1 , pr)
# Vb. load new initial state then run for num-1 steps with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis, IsFFECollection, IsPosInt, IsBool], function(x, B, ist, num, pr)
local  i, sequence,  seq, taps, divs; 
# check basis - simple check , only checking if number of basis elms makes sense, 
# not checking if its a lin indep set coz if its not it wont pass tru the IsBasis filter, so we should be fine  
	divs := DivisorsInt(DegreeOverPrimeField(UnderlyingField(x)));
	if not \in(Length(B),divs) then 
		Error("check if youre using correct basis!");
		return fail;
	fi; 
	

# load FSR 
	seq := LoadFSR(x,ist); # the seq_0 element 
# print header, init state and seq_0

	if pr then 
		Print("using basis B := ",BasisVectors(B),"\t\n");		

		Print("elm \t\t");
		Print( "[ ",Length(x)-1,",");
		for i in [2.. Length(x)-1] do
			Print("...");
		od;
		Print(",0 ]");
		Print( "  with taps  ",OutputTap(x),"\n");	

		Print("\t\t", (IntVecFFExt(B,x!.state)));  				# NOT reversed !!!! 
		if Length(OutputTap(x))=1 then Print("\t\t", IntFFExt(B,seq) , "\n");
		else  Print("\t\t",  IntVecFFExt(B,seq) , "\n");
		fi;			
	fi;
# start run
	sequence := RunFSR(x,B, num, pr);		
	Add(sequence,seq,1);	# seq_0 at the beginning	

	return sequence;
end);




# VI. load new initial state then run for num-1 steps without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR,IsFFECollection, IsPosInt], function(x, ist, num)
	return RunFSR(x, Basis(UnderlyingField(x)), ist, num, false);
end);

# VIIb. load new initial state then run without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis, IsFFECollection, IsBool], function(x, B, ist , pr)
	return RunFSR(x, B, ist, 2^Length(x) + Length(x), pr);
end);


# VII. load new initial state then run without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsFFECollection], function(x, ist )
	return RunFSR(x,  Basis(UnderlyingField(x)), ist, 2^Length(x) + Length(x), false);
end);



# NONLINEAR STEP 
# rationale behind copied code is speed: could be a very long sequence, dont want to many functions calling eachother 

# VIIIb. run for num steps with the same nonlinear input on each step and with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis, IsFFE, IsPosInt, IsBool], function(x, B, elm, num, pr)
local seq, sequence, nrsteps, treshold, i, divs; 


# check basis - simple check , only checking if number of basis elms makes sense, 
# not checking if its a lin indep set coz if its not it wont pass tru the IsBasis filter, so we should be fine  
	divs := DivisorsInt(DegreeOverPrimeField(UnderlyingField(x)));
	if not \in(Length(B),divs) then 
		Error("check if youre using correct basis!");
		return fail;
	fi; 


# check num
	treshold := 2^Length(x) + Length(x); #(if primitive thats one period plus one length of FSR)
	if num > treshold then 
		Print("over the threshold, will only output the first ",treshold," elements of the sequence\n");
		nrsteps := treshold;
	else 	nrsteps := num;
	fi;
#start run
	sequence := [];		
	for i in [1.. nrsteps] do 
		seq := StepFSR(x,elm);
		Add(sequence, seq); #append at the end of the list: seq_0,seq_1,seq_2, ...
#print on every step 
		if pr then 
			Print("\t\t", IntVecFFExt(B, x!.state));  				# NOT reversed !!!! 
			if 	Length(OutputTap(x))=1 then Print("\t\t", IntFFExt(B, seq) , "\n");
			else  	Print("\t\t",  IntVecFFExt(B, seq) , "\n");
			fi;			
		fi;
	od; 

	return sequence;
end);



# IX. run for num steps with the same nonlinear input on each step without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsFFE, IsPosInt], function(x, elm, num)
	return RunFSR(x, Basis(UnderlyingField(x)), elm, num, false);
end);


# Xb. run for num steps with the same nonlinear input on each step without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis,  IsFFE, IsBool], function(x, B, elm, pr)
	return RunFSR(x, B, elm, 2^Length(x) + Length(x), pr);
end);


# X. run for num steps with the same nonlinear input on each step without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsFFE], function(x, elm)
	return RunFSR(x,  Basis(UnderlyingField(x)), elm, 2^Length(x) + Length(x), false);
end);




# XIb. run for num steps with the different nonlinear input on each step with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsBasis, IsFFECollection, IsFFECollection, IsBool], function(x, B, ist, elmvec, pr)
local  sequence,  treshold, num, nrsteps, seq , i, divs; 

# check basis - simple check , only checking if number of basis elms makes sense, 
# not checking if its a lin indep set coz if its not it wont pass tru the IsBasis filter, so we should be fine  
	divs := DivisorsInt(DegreeOverPrimeField(UnderlyingField(x)));
	if not \in(Length(B),divs) then 
		Error("check if youre using correct basis!");
		return fail;
	fi; 



# load FSR 
	seq := LoadFSR(x,ist); # the seq_0 element 
	
# print header, init state and seq_0
	if pr then 

		Print("elm \t\t");
		Print( "[ ",Length(x)-1,",");
		for i in [2.. Length(x)-1] do
			Print("...");
		od;
		Print(",0 ]");
		Print( "  with taps  ",OutputTap(x),"\n");	
		Print(" \t\t");
		Print((IntVecFFExt(B,x!.state)));  				# NOT reversed !!!! 
		if Length(OutputTap(x))=1 then Print("\t\t", IntFFExt(B,seq) , "\n");
		else  Print("\t\t",  IntVecFFExt(B,seq) , "\n");
		fi;			
	fi;


	treshold := 2^Length(x) + Length(x);  
	num := Length(elmvec);
	if num > treshold then 
		Print("over the threshold, will only output the first ",treshold," elements of the sequence\n");
		nrsteps := treshold;
	else 	nrsteps := num;
	fi;
#start run
	sequence := [];		
	for i in [1.. nrsteps] do 
		seq := StepFSR(x,elmvec[i]);
		Add(sequence, seq); #append at the end of the list: seq_0,seq_1,seq_2, ...
#print on every step 
		if pr then 
			Print(IntFFExt(B,elmvec[i]),"\t\t");  				# NOT reversed !!!! 		
			Print(IntVecFFExt(B,x!.state));  				# NOT reversed !!!! 
			if 	Length(OutputTap(x))=1 then Print("\t\t", IntFFExt(B, seq) , "\n");
			else  	Print("\t\t",  IntVecFFExt(B, seq) , "\n");
			fi;			
		fi;
	od; 



	Add(sequence,seq,1);	# seq_0 at the beginning
	return sequence;
end);


# XI. run for num steps with the different nonlinear input on each step with/without print to shell
InstallMethod(RunFSR, "run FSR", [IsFSR, IsFFECollection, IsFFECollection], function(x, ist, elmvec)
	return RunFSR(x, Basis(UnderlyingField(x)), ist, elmvec, false);

end);



Print("fsr.gi OK,\t");