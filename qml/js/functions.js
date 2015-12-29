function installEyeD3() {
    if(!eyed3.check()) {
        eyed3.untar();
        console.log("Untared");
        eyed3.install();
        eyed3.deleteCompileDir();
        return eyed3.check();
    }
    return true;
}
