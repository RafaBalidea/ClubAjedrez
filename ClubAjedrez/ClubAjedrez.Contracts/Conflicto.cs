namespace ClubAjedrez.Contracts;

// Cuerpo de las respuestas 409: otro usuario modificó el registro antes.
// Actual es el registro tal como está en el servidor (que siempre gana), con su Version actual.
// En el cliente se lee con ApiException.GetContentAsAsync<Conflicto<T>>().
public record Conflicto<T>(string Mensaje, T Actual);
