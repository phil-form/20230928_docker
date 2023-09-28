import * as jwt from 'jsonwebtoken';

export class AuthGuard
{
    public static checkAuthorization(req: any, res: any, next: any) {
        // normalement le jeton se trouve dans le header Authorization, mais
        // on pourrait aussi imaginer qu'il soit dans le body ou même dans l'url
        let token = req.body.token || req.query.token || req.headers['x-access-token'] || req.headers['authorization'];
        // s'il y a bien un token
        if (token) {
            // si le jeton est dans Authorization, il est précédé par cette string dont on se débarrasse
            token = token.replace('Bearer ', '');

            // on demande à JWT de valider le jeton sur base de la clé secrète
            jwt.verify(token, 'my-super-secret-key', function (err: any, decoded: any) {
                if (err) {
                    // si le jeton est corrompu, on renvoie un message d'erreur au client
                    return res.json({ success: false, message: 'Failed to authenticate token.' });
                } else {
                    // si le jeton est correct, on stocke sa version "décodée", càd la charge utile,
                    // dans la requête afin que les filtres suivants puissent y avoir directement accès.
                    req.decoded = decoded;
                    // on appelle le filtre suivant
                    next();
                }
            });
        } else {
            // s'il n'y a pas de token, on retourne une erreur HTTP 403 (accès refusé)
            return res.status(403).send({
                success: false,
                message: 'No token provided.'
            });
        }
    }

}
