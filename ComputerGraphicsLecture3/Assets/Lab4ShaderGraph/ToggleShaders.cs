using UnityEngine;
using System;

public class ToggleShaders: MonoBehaviour
{

    public GameObject simpleSpecular;
    public GameObject ambient;
    public GameObject Lambert;


    private void Start()
    {
        simpleSpecular.SetActive(true);
        ambient.SetActive(false);
        Lambert.SetActive(false);
    }




    // Update is called once per frame
    void Update()
    {


        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            simpleSpecular.SetActive(true);
            ambient.SetActive(false);
            Lambert.SetActive(false);
        }

        if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            simpleSpecular.SetActive(false);
            ambient.SetActive(true);
            Lambert.SetActive(false);
        }

        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            simpleSpecular.SetActive(false);
            ambient.SetActive(false);
            Lambert.SetActive(true);
        }


    }
}