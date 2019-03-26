package main

import (
	"fmt"
	"github.com/caiqingfeng/chainstack-core/common/util"
	"github.com/fatih/color"
	"github.com/gosuri/uiprogress"
	"os"
	"os/exec"
	"path"
	"sync"
	"time"
)

const libPath = "go/src/golang.org/x"

var libs = []string{"net", "tools", "text", "sys", "lint", "crypto", "time", "image"}

var status = "Update"

func main() {
	haveGit()
	createDir(path.Join(util.HomeDir(), libPath))

	uiprogress.Start()                       // start rendering
	bar := uiprogress.AddBar(len(libs) * 10) // Add a new bar

	bar.PrependFunc(func(b *uiprogress.Bar) string {
		if b.Current()/10 == len(libs) {
			return fmt.Sprintf("%s\n", color.GreenString(fmt.Sprintf("%6s", "Done")))
		}

		return fmt.Sprintf("%s: %s\n", status, color.YellowString(fmt.Sprintf("%6s", libs[b.Current()/10])))
	})

	bar.AppendFunc(func(b *uiprogress.Bar) string {
		info := color.New(color.FgWhite, color.BgGreen).SprintFunc()
		return fmt.Sprintf("%s", info(fmt.Sprintf("%d%%", int(b.CompletedPercent()))))
	})

	fmt.Println("Start update or clone golang/x/, please wait...")
	for _, lib := range libs {
		var wg sync.WaitGroup
		wg.Add(1)
		go func() {
			defer wg.Done()
			updateLib(lib)
		}()

		for i := 0; i < 9; i++ {
			bar.Incr()
			time.Sleep(100 * time.Millisecond)
		}

		wg.Wait()
		bar.Incr()
	}
	uiprogress.Stop()
}

func updateLib(lib string) {
	destPath := path.Join(util.HomeDir(), libPath, lib)
	if !checkDirExists(destPath) {
		status = "Clone"
		cmd := exec.Command("git", "clone", fmt.Sprintf("https://github.com/golang/%s.git", lib), destPath)
		out, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println(color.RedString(string(out)))
			os.Exit(2)
		}
	} else {
		status = "Update"
		cmd := exec.Command("git", "-C", destPath, "pull")
		out, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println(color.RedString(string(out)))
			os.Exit(2)
		}
	}
}

func checkDirExists(dir string) bool {
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		return false
	}
	return true
}

func createDir(path string) {
	err := os.MkdirAll(path, os.ModePerm)
	if err != nil {
		fmt.Println(err)
	}
}

func haveGit() {
	_, err := exec.LookPath("git")
	if err != nil {
		fmt.Println(color.RedString("git not found, please install git or set git to path"))
		os.Exit(2)
	}
}
