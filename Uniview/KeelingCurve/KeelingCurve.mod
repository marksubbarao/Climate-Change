filepath +:./modules/KeelingCurve
			

coord
{
  name          c_MaunaLoa
  parent        Earth

  # Keep this at 1 meter
  unit          10000.0000
  entrydist     10000
  # Change this file to place on desire longitude/latitude and altitude
  positionfile  MaunaLoaPos.conf

  rotation
  {
    surfacepositioner
    {
      static hpr 180.0 0.0 90
    }
  }
}

object KeelingCurve sgOrbitalObject
{
	coord c_MaunaLoa
	geometry SG_USES KeelingCurve.conf
	targetradius 30	
	cameraradius 0.5
	scalefactor 1.75
	guiName /Solar System/Planets/Earth/KeelingCurve
	off
}



