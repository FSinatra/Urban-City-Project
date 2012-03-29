using UnityEngine;
using System.Collections;

public class CreateBPortal : MonoBehaviour {

	public GameObject PortalB;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	public void OnTriggerEnter( Collider col)
	{
	
		Vector3 impactPos = this.transform.position + new Vector3(0, 3, 0);
		PortalB.transform.position = impactPos;
		
	}
}
