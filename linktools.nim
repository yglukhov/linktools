import strutils

proc libHasSymbol*(lib, sym: static[string]): bool {.compileTime.} =
    const cmdline = "linktools libhassym " & lib & " " & sym
    const res = staticExec(cmdline, cache = cmdline).strip()
    res == "true"

when isMainModule:
    import osproc, os, cligen
    proc libhassym(lib, sym: string) =
        let tmpFile = getTempDir() / "libhassymcheck.nim"
        writeFile(tmpFile, "proc " & sym & "() {.importc.}\l" & sym & "()")
        let (_, r) = execCmdEx("nim c --passL:-l" & lib & " " & quoteShell(tmpFile))
        if r == 0: echo "true"

    dispatchMulti("?", [libhassym])
