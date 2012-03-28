using UnityEngine;
using System.Collections;


public class PortalAnim : MonoBehaviour {


	
	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {

		if (Input.GetKey(KeyCode.W) == true && Input.GetKey(KeyCode.LeftShift) == false)
			{
				animation.Play("PortalGunBob");
				
			}
	 	else if (Input.GetKey(KeyCode.LeftShift) == true)
		{
			animation.Play("PortalGunSprint");	
		}
		
		
	}
}
