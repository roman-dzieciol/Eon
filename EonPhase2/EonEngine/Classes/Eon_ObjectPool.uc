//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Eon_ObjectPool extends ObjectPool;


simulated function Object AllocateObjectFor(class ObjectClass, optional Object context)
{
	local Object	Result;
	local int		ObjectIndex;

	for(ObjectIndex=0; ObjectIndex<Objects.Length; ObjectIndex++)
	{
		if(Objects[ObjectIndex].Class == ObjectClass)
		{
			Result = Objects[ObjectIndex];
			Objects.Remove(ObjectIndex,1);
			break;
		}
	}
	if( Result == None )
	{
		Result = new(context) ObjectClass;
	}
	return Result;
}

simulated function LoadObjects( ObjectPool OP )
{
	local int i;
	for(i=0; i<OP.Objects.Length; i++)
	{
		Objects[i] = OP.Objects[i];
	}
	Log("LoadObjects" @ OP.Objects.Length,'Log');
}

DefaultProperties
{
}
