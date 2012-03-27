using UnityEngine;
using System.Collections;

public class CameraZoom : MonoBehaviour {
	public Camera MainCam;
	public bool ZoomIn = false;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	if (Input.GetMouseButtonDown(2) == true)
		{
			if (ZoomIn == false)
			{
				MainCam.fieldOfView = 24.6F;
				ZoomIn = true;
			}
			else if (ZoomIn == true)
			{
				MainCam.fieldOfView = 47.9F;	
				ZoomIn = false;
			}
		}
	
	}
}
