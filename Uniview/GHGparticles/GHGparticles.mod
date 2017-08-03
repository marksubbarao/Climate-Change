filepath +:./modules/GHGparticles
			

coord
{
  name          c_MaunaLoa_2
  parent        Earth

  # Keep this at 1 meter
  unit          0.001000
  entrydist     10000
  # Change this file to place on desire longitude/latitude and altitude
  positionfile  MaunaLoaPos2.conf

  rotation
  {
    surfacepositioner
    {
      static hpr 180.0 0.0 0.0
    }
  }
}

object BKGparticles sgOrbitalObject
{
	coord c_MaunaLoa_2
	geometry SG_USES BKGparticles.conf
	scalefactor 1


	
	targetradius 300	
	cameraradius 30
	lsize 10000000
	guiName /Climate Change/Greenhouse Gas/BKG particles
	off
}

object MainParticles sgOrbitalObject
{
	coord c_MaunaLoa_2
	geometry SG_USES MainParticles.conf
	scalefactor 1


	
	targetradius 300	
	cameraradius 30
	lsize 10000000
	guiName /Climate Change/Greenhouse Gas/Main Particles
	off
}

object LightWaves sgOrbitalObject
{
	coord c_MaunaLoa_2
	geometry SG_USES Lightwaves.conf
	scalefactor 1


	
	targetradius 300	
	cameraradius 30
	lsize 10000000
	guiName /Climate Change/Greenhouse Gas/Lightwaves
	off
}

object MainLightWaves sgOrbitalObject
{
	coord c_MaunaLoa_2
	geometry SG_USES MainLightWaves.conf
	scalefactor 1


	
	targetradius 300	
	cameraradius 30
	lsize 10000000
	guiName /Climate Change/Greenhouse Gas/Main Lightwaves
	off
}

object GHGParticles sgForward
{
	[fw]	add	BKGparticles	
	[fw]	add	MainParticles	
	[fw]	add	LightWaves	
	[fw]	add	MainLightWaves
	[fw]	guisubprop orbital	/Climate Change/Greenhouse Gas
}
